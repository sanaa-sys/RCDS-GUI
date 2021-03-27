Ncnt = size(g_data,1);

[tmpobj, indxobj] = sort(g_data(:,Nvar+1));

isel = 1; %default
fm = tmpobj(isel);
imp = indxobj(isel);

xm = (g_data(imp,1:Nvar)'-vrange(:,1))./(vrange(:,2)-vrange(:,1));
for ii=1:Ncnt
    x1 = (g_data(ii,1:Nvar)'-vrange(:,1))./(vrange(:,2)-vrange(:,1));
    dist = norm(x1 - xm);
    x_data(ii,:) = [x1(:)',g_data(ii,Nvar+1), dist];
end

%find the best solution through the history
h_data = zeros(size(g_data))*NaN;
xh_data = zeros(size(x_data));
h_data(1,:) = g_data(1,:);
xh_data(1,:) = x_data(1,:);
for ii=2:Ncnt
    h_data(ii,:) = h_data(ii-1,:);
    xh_data(ii,:) = xh_data(ii-1,:);
    if g_data(ii,Nvar+1)<h_data(ii,Nvar+1)
        h_data(ii,:) = g_data(ii,:);
        xh_data(ii,:) = x_data(ii,:);
    end
end

hdata.xm = xm;
hdata.fm = fm;
hdata.x_data = x_data;

%% Plot Figure

figure(3)
    a1=subplot(3,1,1)
    plot(1:Ncnt, sqrt(g_data(:,Nvar+1)),'-',1:Ncnt, sqrt(h_data(:,Nvar+1)),'r-')
    ylabel('$Objective \ \sigma_y \ (\mu m)$', 'interpreter', 'latex')
    xlabel('Iterations', 'interpreter', 'latex')
    %legend('all', 'best',0)
    set(gca,'xlim',[1, Ncnt])
    %enhance_plot
    
    a2=subplot(3,1,2)
    %plot(1:Ncnt,hdata.x_data(:,Nvar+2),1:Ncnt,hdata.xh_data(:,Nvar+2),'r')
    plot(1:Ncnt,x_data(:,Nvar+2),1:Ncnt,xh_data(:,Nvar+2),'r')
    ylabel('$Distance$', 'interpreter', 'latex')
    xlabel('Iterations', 'interpreter', 'latex')
    set(gca,'xlim',[1, Ncnt])
    %enhance_plot
    
    a3=subplot(3,1,3)
    plot(1:Ncnt,hdata.x_data(:,1:Nvar))
    ylabel('$Parameters$','interpreter', 'latex')
    xlabel('Iterations', 'interpreter', 'latex')
    set(gca,'xlim',[1, Ncnt])
    %enhance_plot
    
    linkaxes([a1,a2,a3],'x');