clear all

% Files and directories
% enter directories with trailing slashes .../
indir  = '<indir>';
outdir = '<outdir>';
outfile = '<outfile>';

file_short = '<infile>';
file_long  = '<infile>';


% load data
[datashort.x, datashort.y] = eprload(strcat(indir, file_short));
[datalong.x, datalong.y] = eprload(strcat(indir, file_long));

% stitch it
[data, params] = stitchELDOR(datashort.x, datashort.y, datalong.x, datalong.y)

% plot it
figure(1)
plot(data.short.x,real(data.short.y),data.long.x,real(data.long.y))
figure(2)
plot(data.short.x,imag(data.short.y),data.long.x,imag(data.long.y))

figure(3)
plot(data.stitched.x, data.stitched.y, data.interp.x, data.interp.y)

% save it
out = [ data.interp.x real(data.interp.y) imag(data.interp.y) ]';
% out = [ data.stitched.x real(data.stitched.y) imag(data.stitched.y) ]';

outfile = strcat(outdir, outfile);

fid = fopen(outfile, 'w');
fprintf(fid,'%13.7e %13.7e %13.7e\n',out);
fclose(fid);
