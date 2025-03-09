iecg = 2555;
[b,a] = butter(3,[.5 10]/(fs/2));
x = S(:,iecg,2);
x = filtfilt(b,a,x);
 [spikes] = spikes_detection_PPG_project(x,fs); % Lead II
% spikes(diff(spikes)<100) = []; % remove QRS too closes
% figure
sp = round(spikes/1000*fs);
figure(1)
clf(1)
plot(S(:,iecg,2));
hold on
plot(sp,S(sp,iecg,2),'o')
grid on