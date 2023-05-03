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
%defnining variables
a=xray;
n=50;
m=400;
%defining values within the class
a.d=150;
so=a.d;
a.thick=0;
%thin lens equation for determing si
f=1/((a.nglass-1)*2/a.R1);
si=1/(1/f-1/so);
%matrix calls for propagation to a thin lens
m1=a.propdist(so);
m2=a.curvedrefrac(a.nair,a.nglass,a.R1);
m3=a.propdist(1);
m4=a.curvedrefrac(a.nglass,a.nair,-a.R1);
m5=a.propdist(si);
%repmat of the above matrices to apply to the copies of the vector rays
mm1=repmat(m1,1,1,n);
mm2=repmat(m2,1,1,n);
mm3=repmat(m3,1,1,n);
mm4=repmat(m4,1,1,n);
mm5=repmat(m5,1,1,n);
%n-initial vectors all with n rays per entry, probably should create a
%separate variable so I can have many instances with fewer rays per
%instance
vec(1,:,:)=zeros(1,n,n);
vec(2,:,:)=a.ang(n,so);
%%
%propagation of the vector with plot holds to piecewise construct the path
vec=pagemtimes(mm1,vec);
vec=pagemtimes(mm2,vec);
yplot=vec(1,:,:);
figure; plot([0,so],[zeros(n,1),yplot(1,:,1)'],'r');
hold on;
title('thin lens')
xlabel('z - optical axis');ylabel('y')
vec=pagemtimes(mm3,vec);
vec=pagemtimes(mm4,vec);
plot([so,so+a.thick],[yplot(1,:,1)',(vec(1,:,1))'],'r');
yplot=vec(1,:,:);
vec=pagemtimes(mm5,vec);
plot([so+a.thick,so+a.thick+si],[yplot(1,:,1)',(vec(1,:,1))'],'r');
hold off;
%%
%creation of vectors and propagation of the rays for complex index of
%refraction
a.thick=30;
%function call for the interface
mflat=a.flatrefrac(a.nair,a.ncarbon);
mmflat=repmat(mflat,1,1,n);
flatvec(1,:,:)=zeros(1,n,n);
flatvec(2,:,:)=a.ang(n,so);
%propagate n page entries to the surface
flatvec=pagemtimes(mm1,flatvec);
yplot=flatvec(1,:,1);
figure; plot([0,so],[zeros(n,1),yplot'],'r'); title('ray tracing for complex index of refraction')
xlabel('optical axis');ylabel('y')
hold on;
flatvec=pagemtimes(mmflat,flatvec);
flatvec=pagemtimes(mm5,flatvec);
plot([so,so+a.thick],[yplot',(flatvec(1,:,1))'],'r');
%%
%propagation through a thick lens. Construction of vector, repmat functions
%and propagation through the system. The thickl function can take as inputs
%the index of refractions of interfaces, radii of curvature, and thickness
%of lens. Uncommenting thickl(0,0,0,0,0) will run the program with
%predefined values
a.thick=100;
thickl=a.thicklens(a.nair,a.nglass,100,-100,a.thick);
%thickl=a.thicklens(0,0,0,0,0);
mthickl=repmat(thickl,1,1,n);
%vector and angles creation
tvec(1,:,:)=zeros(1,n,n);
tvec(2,:,:)=a.ang(n,so);
%propagation
tvec=pagemtimes(mm1,tvec);
yplot=tvec(1,:,1);
figure; plot([0,so],[zeros(n,1),yplot(1,:,1)'],'b');
hold on;
title('Thick lens')
xlabel('z - optical axis');ylabel('y')
tvec=pagemtimes(mthickl,tvec);
plot([so,so+a.thick],[yplot',(tvec(1,:,1))'],'b');
yplot=tvec(1,:,1);
tvec=pagemtimes(mm5,tvec);
plot([so+a.thick,so+a.thick+si],[yplot(1,:,1)',(tvec(1,:,1))'],'b');
%%
%this function takes the final final propagation information for the
%vectors and angles, and creates an intensity map of where we would expect
%this line source to be. It then creates a pixellated dectector map with
%a definable region. 
a.detector(tvec,length(tvec))

