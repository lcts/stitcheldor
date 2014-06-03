clear all

% Files and directories
% enter directories with trailing slashes .../
indir  = '/home/cengelha/Daten/Aaron/2014-05-29/';
outdir = '/home/cengelha/Daten/Aaron/2014-05-29/';
outfile = 'SOMD 5CS 324 359 Apo EK 6us stitched.dat';

file_short = 'SOMD 5CS 324 359 Apo EK 2us.DSC';
file_long  = 'SOMD 5CS 324 359 Apo EK 6us.DSC';

% parameters
autophase = true; % automatically phase-correct data, true or false
offset = 0;       % shift splitpoint towards 0ns

% load data
[datashort.x, datashort.y] = eprload(strcat(indir, file_short));
[datalong.x, datalong.y] = eprload(strcat(indir, file_long));

% stitch it
[data, params] = stitchELDOR(datashort.x, datashort.y, datalong.x, datalong.y, 'offset', offset, 'autophase', autophase);

% plot it
figure(1)
plot(data.short.x,real(data.short.y),data.long.x,real(data.long.y))
figure(2)
plot(data.short.x,imag(data.short.y),data.long.x,imag(data.long.y))

figure(3)
plot(data.stitched.x, data.stitched.y, data.interp.x, data.interp.y + 0.2 * max(data.interp.y))

% save it
out = [ data.interp.x real(data.interp.y) imag(data.interp.y) ]';
% out = [ data.stitched.x real(data.stitched.y) imag(data.stitched.y) ]';

outfile = strcat(outdir, outfile);

fid = fopen(outfile, 'w');
fprintf(fid,'%13.7e %13.7e %13.7e\n',out);
fclose(fid);
