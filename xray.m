classdef xray
    properties
        x1; % userinput 1
        x2; % userinput 2
        x3; % userinput 3
        x4; % userinput 4
        ncarbon=1-4.8155e-4-1i*4.8121e-05;
        ngold=1-2.1062e-3-1i*1.0306e-3;
        nsilver=1-1.5720e-3-1i*7.3590e-4;
        n1=1;
        n2=1.5;
        nglass=1.4;
        nair=1;
        nwater=1.333;
        beta;
        d;
        si;
        dp; % prism path length
        R;
        R1=100;
        R2=-100;
        f;
        thick=50;
        lensdiam=20;
        k;
    end

    methods
        % function for user inputs, want to add if else statements so that
        % random values of value definitions will be chosen if user doesn't
        % pick anything
        function out=userinput(dum)
            prompt=['please input the following parameter, distance of' ...
                ' propagation in mm: \n'];
            dum.d=input(prompt);
            out=dum.d;
        end
        % gaussian weighted detector from in class. Here, instead of using
        % random initial coordinates I'll use the beam locations as the
        % location for a point. Also want to rewrite this to be neater.
        function out=detector(dum,vec,numpoints)
            % dim=linspace(0,30);
            mean=30;
            sigma=10;
            %numpoints=10000;
            %m=pagetranspose(vec);
            m=vec;
            m=m+70;%round(max(m(:,1,:)));
            detsize=60;
            %m=sigma*randn(numpoints,2)+mean;
            figure; hold on
            title('array of ray locations (cross section)')
            xlabel('x - horizontal');ylabel('y')
            for i=1:numpoints
            scatter(i,m(2,:,i));
            end
            hold off
            det=zeros(detsize);
            for i=1:numpoints
               
            for ll=1:numpoints
                %jj=round(m(i,1,ll)/2);
                kk=round(m(1,i,ll)/2);
                if ll<1 
                   ll=1;
                end
                if ll>detsize
                   ll=detsize;
                end
                if kk>detsize
                   kk=detsize;
                end
                if kk<1
                   kk=1;
                end
                
                det(ll,kk)=det(ll,kk)+1;
            end
            end
            
            figure; imagesc(imrotate(det,90));colormap turbo;
            title('Intensity detector')
            xlabel('pix');ylabel('pix')
        end

        % the following functions define the matrix representations for
        % geometrical optical ray tracing

        % function deifines propagation through free space
        function out=propdist(dum,dist)
            if dist==0
                out=[1,dum.d;0,1];
            else
                out=[1,dist;0,1];
            end
        end
        % refraction: flat interface
        function out=flatrefrac(dum,n1,n2)
            if n1==0 && n2==0
                out=[1,0;0,dum.n1/dum.n2];
            else
                out=[1,0;0,n1/n2];
            end
        end

        % refraction: curved interface
        function out=curvedrefrac(dum,n1,n2,R)
            if n1==0 && n2==0 && R==0
                out=[1,0;(dum.n2-dum.n1)/dum.R*dum.n2,dum.n1/dum.n2];
            else
                out=[1,0;(n1-n2)/(R*n2),n1/n2];
            end
        end

        % reflection: flat mirror
        function out=mirrorreflec(dum)
            out=[1,0;0,1];
        end

        % refraction: thin lens
        function out=thinlens(dum,f)
            if f==0
                out=[1,0;-1/dum.f,1];
            else
                out=[1,0;-1/f,1];
            end
        end

        % refraction: thick lens
        function out=thicklens(dum,n1,n2,R1,R2,t)
            if n1==0&&n2==0&&R1==0&&R2==0&&t==0
                surf2=[1,0;(dum.n1-dum.n2)/(dum.R1*dum.n2),dum.n1/dum.n2];
                surf1=[1,0;(dum.n2-dum.n1)/(dum.R2*dum.n1),dum.n2/dum.n1];
                thickness=[1,dum.thick;0,1];
                out=surf2*thickness*surf1;
            else
                surf2=[1,0;(n1-n2)/(R1*n2),n1/n2];
                surf1=[1,0;(n2-n1)/(R2*n1),n2/n1];
                thickness=[1,t;0,1];
                out=surf2*thickness*surf1;
            end
        end

        % refraction: single prism
        function out=singleprism(dum)
            out=[dum.k,dum.dp/n*dum.k;0,1/dum.k];
        end

        % function to generate new random angles for each call
        function out=ang(dum,n,so)
            out=2*atan((dum.lensdiam/2)/so)*randn(n,1,n)-atan((dum.lensdiam/2)/so);
        end
    end
    methods(Static)
    end
end

