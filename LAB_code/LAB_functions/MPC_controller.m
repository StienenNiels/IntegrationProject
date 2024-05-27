A_MPC = sysd.A;
B_MPC = sysd.B;
C_MPC = eye(3);

% Normalization factors
    wx1 = 1;
    wx2 = 1;
    wx3 = 1/250;
    wu1 = 1;
    
    % Penalization factors
    qx1 = 100;
    qx2 = 1e0;
    qx3 = 1e0;
    qu1 = 5e-4;
    
    % Q,R,L matrices
    Q_MPC = [wx1*qx1, 0, 0;
         0, wx2*qx2, 0;
         0, 0, wx3*qx3];
    R_MPC = wu1*qu1;
    L_MPC = 40;
    x0 = [0;0;0];
    [A_MPC,B_MPC,C_MPC,Q_MPC,R_MPC,M_MPC,P_MPC,x0] = rate_change_pen(A_MPC,B_MPC,Q_MPC,R_MPC,L_MPC,x0);
    dim.N = 15;
    dim.nx = 4;
    dim.nu = 1;
    dim.ny = 4;
    [T,S]=predmodgen(A_MPC, B_MPC, C_MPC, dim);
    [left,right]=costgen(T,S,Q_MPC,R_MPC,dim,x0,P_MPC,M_MPC);

function [A,B,C,Q,R,M,P,x0] = rate_change_pen(A,B,Q,R,L,x0)
    % Augment the state with the previous control action
    % This allows us to formulate it as a standard LQR problem with cross
    % terms.
    % For reference look at exercise set 2, problem 5
    % x is now 16 states being: [u v w phi theta psi p q r X_b Y_b Z_b Omega1 Omega2 Omega3 mu]
    n_x = size(A,1);
    n_u = size(B,2);
    
    % Calculate terminal cost using the discrete algebraic Ricatti equation
    P = idare(A,B,Q,R);
    
    % Extend the system matrices
    A = [A, zeros(n_x,n_u);
         zeros(n_u,n_x), zeros(n_u,n_u)];
    B = [B; eye(n_u)];
    C = eye(n_x+n_u);
    
    % Extend the weighing matrices
    Q = [Q,zeros(n_x,n_u);
         zeros(n_u,n_x),L];
    R = R+L;
    M = -[zeros(n_x,n_u);L];
    P = [P,zeros(n_x,n_u);
             zeros(n_u,n_x),zeros(n_u,n_u)];
    
    % Extend the initial state
    x0 = [x0;zeros(n_u,1)];
end

function [T,S]=predmodgen(A_MPC, B_MPC, C_MPC, dim)
    % Prediction matrices generation
    % This function computes the prediction matrices to be used in the
    % optimization problem

    % Prediction matrix from initial state
    T=zeros(dim.ny*(dim.N+1),dim.nx);
    
    for k=0:dim.N
        Pslice = C_MPC*A_MPC^k;
        T(k*dim.ny+1:(k+1)*dim.ny,:)=Pslice;
    end
    
    % Prediction matrix from input
    S=zeros(dim.ny*(dim.N+1),dim.nu*(dim.N));
    
    for k=1:dim.N
        for i=0:k-1
            % Calculate slice
            Sslice = C_MPC*A_MPC^(k-1-i)*B_MPC;
            % Update full S matrix
            S(k*dim.ny+1:(k+1)*dim.ny,i*dim.nu+1:(i+1)*dim.nu)= Sslice;
        end
    end
end

function [H,h]=costgen(T,S,Q,R,dim,x0,P,M)
    % Cost function generation
    % Converts a cost function of the form:
    % V_N(x(0),u_n) = 0.5*sum_{0,N-1}(x'Qx + u'Ru + 2x'Mu) + 0.5x_N'Px_N
    % into a form only dependent on u_N:
    % V_N(u_N) = 0.5u'Hu + h'u + c
    
    if nargin == 6
        M = zeros(dim.nx,dim.nu);
        P = Q;
    end
    
    % Define the bar matrices Qbar, Rbar, Mbar
    Qbar = blkdiag(kron(eye(dim.N),Q),P); 
    Rbar = kron(eye(dim.N),R);
    Mbar = [kron(eye(dim.N),M);zeros(dim.nx,dim.N*dim.nu)];
    
    % Calculate H,h,c
    H = (Rbar + S'*Qbar*S + 2*S'*Mbar);  
    
    % Stabilizing version
    h = (S'*Qbar*T*x0 + Mbar'*T*x0);
end
