clear
clc

loadSim

y = D05_13_h05_Ef_Asbc_R01.data(2:end,2:3);
u = D05_13_h05_Ef_Asbc_R01.data(2:end,5);
z = iddata(y, u, 0.05, 'Name', 'Pendulum');
z.OutputName = {'Pendulum position','Flywheel angular velocity'};
z.OutputUnit = {'rad','rad/s'};
z.InputName = {'Control Signal'};
z.Tstart = 0;
z.TimeUnit = 's';


%% Specification of a Nominal (Initial) Model
% Initial guess for Ktau
Ktau = 0.001;
K1 = 10.8975;
K2 = 0.0393;
K3 = 0.1051;
K4 = 402;
K5 = 0.9403;
A = [0,1,0;
     -K1, -K2, 0;
     0, 0, -K5]
B = [0;K4*Ktau;K4]
C = [1,0,0;0,0,1];
D = [0;0];

%%
% Create an IDSS model object.
ms = idss(A,B,C,D);

%%
% The model is characterized by its matrices, their values, which elements
% are free (to be estimated) and upper and lower limits of those:
ms.Structure.a;

%%
ms.Structure.a.Value;
ms.Structure.a.Free;

%% Specification of Free (Independent) Parameters Using IDSS Models
% So we should now mark that it is only A(2,2) and B(2,1) that are free
% parameters to be estimated.
ms.Structure.a.Free = [0,0,0; 0,1,1; 1,1,0];
ms.Structure.b.Free = [0;1;0];
ms.Structure.c.Free = [0,0,0; 0,0,0]; % scalar expansion used
ms.Structure.d.Free = [0;0];
ms.Ts = 0;  % This defines the model to be continuous

%% The Initial Model
ms; % Initial model


%% Estimation of Free Parameters of the IDSS Model
% The prediction error (maximum likelihood) estimate of the parameters
% is now computed by:
opt = ssestOptions('Display','on');
opt.OutputWeight = [10000,0;0,1]
dcmodel = ssest(z,ms,opt);
dcmodel

%%
% The estimated values of the parameters are quite close to those used
% when the data were simulated (-4 and 1).
% To evaluate the model's quality we can simulate the model with the
% actual input by and compare it with the actual output.
figure(5), clf;
compare(z,ms)
figure(6), clf;
compare(z,dcmodel)

%% 
% We can now, for example plot zeros and poles and their uncertainty
% regions. We will draw the regions corresponding to 3 standard
% deviations, since the model is quite accurate. Note that the pole at the
% origin is absolutely certain, since it is part of the model structure;
% the integrator from angular velocity to position. 
clf
showConfidence(iopzplot(dcmodel),3)



%%
% We find that the estimated |A(1,2)| is close to 1.
% To compare the two model we use the |compare| command:
compare(z,dcmodel,dcmodel2)

%% Specification of Models with Coupled Parameters Using IDGREY Objects
% Suppose that we accurately know the static gain of the dc-motor (from
% input voltage to angular velocity, e.g. from a previous step-response
% experiment. If the static gain is |G|, and the time constant of the
% motor is t, then the state-space model becomes
%
%            |0     1|    |  0  |
%  d/dt x =  |       |x + |     | u
%            |0  -1/t|    | G/t |
%
%            |1   0|
%     y   =  |     | x
%            |0   1|
%

%%
% With |G| known, there is a dependence between the entries in the
% different matrices. In order to describe that, the earlier used way with
% "Free" parameters will not be sufficient. We thus have to write a MATLAB
% file which produces the A, B, C, and D, and optionally also the K and X0
% matrices as outputs, for each given parameter vector as input. It also
% takes auxiliary arguments as inputs, so that the user can change certain
% things in the model structure, without having to edit the file. In this
% case we let the known static gain |G| be entered as such an argument. The
% file that has been written has the name 'motorDynamics.m'.
type motorDynamics

%%
% We now create an IDGREY model object corresponding to this model
% structure: The assumed time constant will be
par_guess = 1;

%%
% We also give the value 0.25 to the auxiliary variable |G| (gain)
% and sample time.
aux = 0.25;
dcmm = idgrey('motorDynamics',par_guess,'cd',aux,0);

%%
% The time constant is now estimated by
dcmm = greyest(z,dcmm,greyestOptions('Display','on'));

%%
% We have thus now estimated the time constant of the motor directly.
% Its value is in good agreement with the previous estimate.
dcmm

%%
% With this model we can now proceed to test various aspects as before.
% The syntax of all the commands is identical to the previous case.
% For example, we can compare the idgrey model with the other
% state-space model:
compare(z,dcmm,dcmodel)

%%
% They are clearly very close.

%% Estimating Multivariate ARX Models 
% The state-space part of the toolbox also handles multivariate (several
% outputs) ARX models. By a multivariate ARX-model we mean the
% following: 

%%
% |A(q) y(t) = B(q) u(t) + e(t)|
%
% Here A(q) is a ny | ny matrix whose entries are polynomials in the
% delay operator 1/q. The k-l element is denoted by:
%
% $$a_{kl}(q)$$
%
% where:
%
% $$a_{kl}(q) = 1 + a_1 q^{-1}    + .... + a_{nakl} q^{-nakl} q$$
%
% It is thus a polynomial in |1/q| of degree |nakl|.
 
%%
% Similarly B(q) is a ny | nu matrix, whose kj-element is:
%
% $$b_{kj}(q) = b_0 q^{-nkk}+b_1 q^{-nkkj-1}+ ... +b_{nbkj} q^{-nkkj-nbkj}$$
%

%%
% There is thus a delay of |nkkj| from input number |j| to output number
% |k|. The most common way to create those would be to use the ARX-command.
% The orders are specified as:
% |nn = [na nb nk]|
% with |na| being a |ny-by-ny| matrix whose |kj|-entry is |nakj|; |nb| and
% |nk| are defined similarly.

%%
% Let's test some ARX-models on the dc-data. First we could simply build
% a general second order model:
dcarx1 = arx(z,'na',[2,2;2,2],'nb',[2;2],'nk',[1;1])

%%
% The result, |dcarx1|, is stored as an IDPOLY model, and all previous
% commands apply. We could for example explicitly list the
% ARX-polynomials by:
dcarx1.a

%%
% as cell arrays where e.g. the {1,2} element of dcarx1.a is the polynomial
% A(1,2) described earlier, relating y2 to y1.

%%
% We could also test a structure, where we know that |y1| is obtained by
% filtering |y2| through a first order filter. (The angle is the integral
% of the angular velocity). We could then also postulate a first order
% dynamics from input to output number 2:
na = [1 1; 0 1];
nb = [0 ; 1];
nk = [1 ; 1];
dcarx2 = arx(z,[na nb nk])

%%
% To compare the different models obtained we use
compare(z,dcmodel,dcmm,dcarx2)

%%
% Finally, we could compare the bodeplots obtained from the input to
% output one for the different models by using |bode|:
%  First output:
dcmm2 = idss(dcmm); % convert to IDSS for subreferencing
bode(dcmodel(1,1),'r',dcmm2(1,1),'b',dcarx2(1,1),'g')

%%
%  Second output:
bode(dcmodel(2,1),'r',dcmm2(2,1),'b',dcarx2(2,1),'g')

%%
% The two first models are more or less in exact agreement. The
% ARX-models are not so good, due to the bias caused by the non-white
% equation error noise. (We had white measurement noise in the
% simulations).

%% Conclusions
% Estimation of models with pre-selected structures can be performed using
% System Identification toolbox. In state-space form, parameters may be
% fixed to their known values or constrained to lie within a prescribed
% range. If relationship between parameters or other constraints need to be
% specified, IDGREY objects may be used. IDGREY models evaluate a
% user-specified MATLAB file for estimating state-space system parameters.
% Multi-variate ARX models offer another option for quickly estimating
% multi-output models with user-specified structure.