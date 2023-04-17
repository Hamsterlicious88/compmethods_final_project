%% comp methods project outline

% x-ray tracing code layout

% - all parameters stored as a structure function
%   and will contain the monte carlo random inital conditions
 
% - user input to define system energies and indicies of refraction
%   for the material

% - function for the time of travel for rays, and the propagation of the
%   rays through the material for various angles

% - plot function for the ray as it travels and reflects / refracts 

% - plot the real and complex index of refraction for the given material

% - The change that we spoke about with Dr. Petruccelli: Using the density
%   of rays coming in, write a function to create an intensity map of the 
%   incoming rays

% - function: every incoming ray is gaussian (assume parallel)

% - function: create gaussian weighted detector

% - plot of the intensity map of the rays (similar to a target plot)

% - If I have time I'd like to animate either the rays as they 
%   progagate through the samples, or a real time creation of the 
%   intensity map as it's being generated by the incoming rays, however 
%   I believe this last step would require rewriting a portion of the
%   either the ray tracing, or the plotting to be done through a delayed
%   loop as the vectorization of the code should generate the entire
%   intensity plot all at once. 
clc; clear all; close all;
a=xray;
% a.userinput
n=300;
a.d=150;
so=a.d;
a.thick=50;
%a.si=200;
f=1/((a.nglass-1)*2/a.R1);
si=1/(1/f-1/so);
m1=a.propdist(so);
m2=a.curvedrefrac(a.nair,a.nglass,a.R1);
m3=a.propdist(a.thick);
m4=a.curvedrefrac(a.nglass,a.nair,-a.R1);
m5=a.propdist(si);
ang=2*atan((a.lensd/2)/so)*rand(n,1)-atan((a.lensd/2)/so);
v(1,:)=zeros(1,n);
v(2,:)=ang;
%%
v=m2*m1*v;
yplot=v(1,:);
figure; plot([0,so],[zeros(n,1),yplot'],'r');
hold on;
v=m4*m3*v;
plot([so,so+a.thick],[yplot',(v(1,:))'],'r');
yplot=v(1,:);
v=m5*v;
plot([so+a.thick,so+a.thick+si],[yplot',(v(1,:))'],'r');
hold off;
%%
mflat=a.flatrefrac(1,0.1);
flatvec(2,:)=ang;
flatvec=m1*flatvec;
yplot=flatvec(1,:);
figure; plot([0,so],[zeros(n,1),yplot'],'r');
hold on;
flatvec=m5*mflat*flatvec;
plot([so,so+a.thick],[yplot',(flatvec(1,:))'],'r');
yplot=flatvec(1,:);
%%
thickl=a.thicklens(1,a.nglass,100,-1,a.thick);
tvec(2,:)=ang;
tvec=m1*tvec;
yplot=tvec(1,:);
figure; plot([0,so],[zeros(n,1),yplot'],'b');
hold on;
tvec=thickl*tvec;
plot([so,so+a.thick],[yplot',(tvec(1,:))'],'b');
yplot=tvec(1,:);
m5=a.propdist(si);
plot([so+a.thick,so+a.thick+si],[yplot',(tvec(1,:))'],'b');