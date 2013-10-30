function fb = get_tri_filterbank(curve,numChans,low,hi,fs)
%function fb = get_tri_filterbank(curve,numChans,{low,hi,fs})
% - curve is the shape to use, the number of points in curve is the length of
% each filter
% - low and hi restrict the range of the filterbanks. e.g. for MFCCs that
% go between 300 and 3400 Hz in a 8000Hz file, we have 300,3400,8000 for
% low,hi,fs. Default is low = 0, hi = fs/2.
if nargin == 2
    low = 0;
    hi = 1;
else
    fs = fs/2; % only deal with first half of the spectrum;
    low = low/fs;
    hi = hi/fs;
end
curve = curve/max(curve); % curve is 0-1

opoints = linspace(low,hi,numChans+2);
npoints = zeros(size(opoints));

c=1;
for i = 1:length(curve)
    if curve(i) >= opoints(c)
        npoints(c) = i;
        c = c+1;
    end
end
% now build the actual filterbanks
fb = zeros(numChans,length(curve));
for i = 1:numChans
    fb(i,npoints(i):npoints(i+1)) = linspace(0,1,npoints(i+1)-npoints(i)+1);
    fb(i,npoints(i+1):npoints(i+2)) = linspace(1,0,npoints(i+2)-npoints(i+1)+1);
end
