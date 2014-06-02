function [ data, phase, offset, deviation ] = autophase(varargin)
% Perform automatic 0th-order phase correction of a complex vector by
% minimizing the signal in the imaginary channel
%
% USAGE:
% dataout = autophase(data)
% [dataout, phase] = autophase(data)
% [dataout, phase, deviation] = autophase(data)
% [dataout, phase, deviation] = autophase(data, 'units', '<value>', 'flip180', <boolean>)
%
% data:             complex data vector to be phase-corrected
% units:            'rad' or 'deg', return phase in degrees or rad
% flip180:          true or false, rotate an additional 180° (because the phase found by
%                   the algorithm could be off by 180°)
%
% dataout:          phase-corrected data
% phase:            the phase used for correction
% deviation:        the deviation of the imaginary part from 0th order polynomial, normalized
%
p = inputParser;
p.addRequired('data', @(x)validateattributes(x,{'numeric'},{'vector'}));
p.addParamValue('units', 'rad', @(x)ischar(validatestring(x,{'rad', 'deg'})));
p.addParamValue('flip180', false, @(x)validateattributes(x,{'logical'},{'scalar'}));
p.FunctionName = 'autophase';
p.parse(varargin{:});

% function for phase correction: Minimize signal intensity in imag. channel:
% Multiply data with phase angle:                     data*exp(i*x(1))
% take the imaginary part and 0-order bg correct it:  imag(...) - x(2)
% square it element-wise:                             (...).^2
% and sum over the resulting vector:                  sum(...)
% Define that as a function of phi:                   f = @(phi)...
f = @(x)sum((imag(p.Results.data*exp(i*x(1))) - x(2)).^2);

% find the minimum deviation from zero 
[ phase, deviation ] = fminsearch(f, [0 0]);
offset = phase(2);
phase = phase(1);

% correct phases
if ~flip180
  data = p.Results.data*exp(i*phase);
else
  data = p.Results.data*exp(i * (phase + pi));
end

deviation = sqrt(deviation)/(length(data)*max(abs(data)));
if p.Results.units == 'deg'; phase = phase/pi*180; end
