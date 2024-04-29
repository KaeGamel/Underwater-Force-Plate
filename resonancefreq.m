
x=(Jan18trial30ax1table.Vertical14(28754:29022,:));
%% 
q=(1); %taking a data point every .016666666667 seconds
[rowsFP, ~]= size(x);
createForcetimevector= 0:q:(rowsFP);%%creating time vector for IGOR AND VIDEOS
create= createForcetimevector';
%%
[~, loc]= max(x);
FREQ_ESTIMATE = create(loc);
title(['Frequency estimate = ',num2str(FREQ_ESTIMATE),' Hz']);

