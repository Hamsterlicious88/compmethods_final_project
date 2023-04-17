classdef xray
    properties
        x1; % userinput 1
        x2; % userinput 2
        x3; % userinput 3
        x4; % userinput 4
        ncarbon;
        ngold;
        nsilver;
        n1=1;
        n2=1.5;
        nglass=1.4;
        nair=1;
        nwater;
        beta;
        d;
        si;
        dp; % prism path length
        R;
        R1=100;
        R2=100;
        f;
        thick;
        lensd=20;
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
        function detector(dum)
            % dim=linspace(0,30);
            mean=30;
            sigma=10;
            numpoints=10000;
            m=sigma*randn(numpoints,2)+mean;
            figure;scatter(m(:,1),m(:,2));
            det=zeros(30);
            for i=1:10000
                jj=round(m(i,1)/2);
                kk=round(m(i,2)/2);
                if jj<1 
                   jj=1;
                end
                if jj>30 
                   jj=30;
                end
                if kk>30
                   kk=30;
                end
                if kk<1
                    kk=1;
                end
                
                det(jj,kk)=det(jj,kk)+1;
            end
            
            figure, imagesc(det);colormap turbo;
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
                surf2=[1,0;(dum.n1-dum.n2)./dum.R1*dum.n2,dum.n1./dum.n2];
                surf1=[1,0;(dum.n2-dum.n1)./dum.R2*dum.n1,dum.n2./dum.n1];
                thickness=[1,dum.thick;0,1];
                out=surf2*thickness*surf1;
            else
                surf1=[1,0;(n1-n2)/(R1*n2),n1/n2];
                surf2=[1,0;(n2-n1)/(R2*n1),n2/n1];
                thickness=[1,t;0,1];
                out=surf2*thickness*surf1;
            end
        end
        % refraction: single prism
        function out=singleprism(dum)
            out=[dum.k,dum.dp/n*dum.k;0,1/dum.k];
        end

    end
    methods(Static)
    end
end

