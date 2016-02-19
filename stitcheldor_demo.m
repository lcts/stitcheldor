clear all

% Files and directories
% enter directories with trailing slashes .../
indir  = '/home/cengelha/Daten/ChR2/nanodiscs/ENBO/';
outdir = '/home/cengelha/Daten/ChR2/nanodiscs/ENBO/ascrobate-reduced-out/';
outfile = 'dark-reduced_stitched.dat';

file_short = '2015-07-29/2015-07-29_ChR2_C79C208_ascorbat_dark_QELDOR_ENBO_50K.DSC';
file_long  = '2015-10-28/2015-10-28_ChR2_C79C208_nano_ascred_dark_QELDOR_ENBO_4us_50K.DSC';

% parameters
autophase = true; % automatically phase-correct data, true or false
offset = 0;       % shift splitpoint towards 0ns

% load data
[datashort.x, datashort.y] = eprload(strcat(indir, file_short));
%datashort.x = datashort.x(1:158);
%datashort.y = datashort.y(1:158);
%tempdata = load(file_short,'ASCII');
%datashort.x = tempdata(:,1);
%datashort.y = tempdata(:,2) + i*tempdata(:,3);
[datalong.x, datalong.y] = eprload(strcat(indir, file_long));

% stitch it
[data, params] = stitchELDOR(datashort.x, datashort.y, datalong.x, datalong.y, 'offset', offset, 'autophase', autophase);

% plot it
figure(1)
plot(data.short.x,real(data.short.y),data.long.x,real(data.long.y))
figure(2)
plot(data.short.x,imag(data.short.y),data.long.x,imag(data.long.y))

figure(3)
hold on
plot(data.stitched.x, real(data.stitched.y), data.interp.x, real(data.interp.y + 0.2 * max(data.interp.y)));
plot(data.stitched.x, imag(data.stitched.y), data.interp.x, imag(data.interp.y + 0.2 * max(data.interp.y)));
hold off

% save it
out = [ data.interp.x real(data.interp.y) imag(data.interp.y) ]';
% out = [ data.stitched.x real(data.stitched.y) imag(data.stitched.y) ]';

outfile = strcat(outdir, outfile);

fid = fopen(outfile, 'w');
fprintf(fid,'%13.7e %13.7e %13.7e\n',out);
fclose(fid);
