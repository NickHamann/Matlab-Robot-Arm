function containerStats(Stats)
%containerStats displays a stacked bar graph with the number of boxes of
% each size indicated for each container and the reject pile.
%   Format: containerStats(Stats). Stats is a structure.

    %Creates a matrix for the bar graph.
    stats_matrix = [Stats(1).Small Stats(1).Medium Stats(1).Large;...
        Stats(2).Small Stats(2).Medium Stats(2).Large;...
        Stats(3).Small Stats(3).Medium Stats(3).Large;...
        Stats(4).Small Stats(4).Medium Stats(4).Large];
    
    close all;
    %Creates a figure and centers it.
    f = figure('Visible', 'off', 'Color', 'white','Units','Normalized',...
        'Position',[.2, .2, .7, .7]);
    movegui(f,'center');
    
    %Creates a stacked bar graph with a legend
    bar(stats_matrix,'stacked');
    set(gca,'XTickLabel',{Stats(1).Country, Stats(2).Country,...
        Stats(3).Country, Stats(4).Country});
    legend({'Small','Medium','Large'},'location','bestoutside');
    xlabel('Countries');
    ylabel('Number of boxes');
    
    %Adds the number of each type of box to the stacked bar graph.
    for i = 1:4
        y1 = Stats(i).Small/2;
        y2 = Stats(i).Small + Stats(i).Medium/2;
        y3 = Stats(i).Small + Stats(i).Medium + Stats(i).Large/2;
        text(i, y1, num2str(Stats(i).Small));
        text(i, y2, num2str(Stats(i).Medium));
        text(i, y3, num2str(Stats(i).Large));
    end
    f.Visible = 'on';
end

