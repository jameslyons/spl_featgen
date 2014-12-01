function rec_signal = deframe_sig(frames, signal_len, frame_len, frame_step, winfunc)
%rec_signal = deframe_sig(frames, signal_len, frame_len, frame_step, wintype)
% frames - a N by frame_len matrix of frames
% signal_len - the length of the original unframed signal (if unknown, use [])
% frame_len, frame_step - should be same as used by frame_sig (framing function)
% winfunc - the same used when framing, this is undone before overlap-add


num_frames = size(frames,1);
indices = repmat(1:frame_len, num_frames, 1) + ...
          repmat((0: frame_step: num_frames*frame_step-1)', 1, frame_len); 
padded_len = num_frames*frame_step + frame_len;
 
if isempty(signal_len)
    signal_len = padded_len;
end

rec_signal = zeros(1,padded_len);
window_correction = zeros(1,padded_len);
%wsyn = 0.5-0.5*cos((2*pi*((0:frame_len-1)+0.5))/frame_len);

win = winfunc(frame_len)';

for i = 1:num_frames
    window_correction(indices(i,:)) = window_correction(indices(i,:)) + win + eps;
    
    rec_signal(indices(i,:)) = rec_signal(indices(i,:)) + frames(i,:);
end

rec_signal = rec_signal./window_correction;
rec_signal = rec_signal(1:signal_len); % discard any padded samples
