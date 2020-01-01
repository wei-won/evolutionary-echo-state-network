%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: /Users/metoo/Documents/experiment/rc/Ensemble RC/GA_RE/GA_RE_v3.0(pass variable)/GA_RE_v3.01(high:low_fix)/weather.xlsx
%    Worksheet: Sheet1
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

% Auto-generated by MATLAB on 2016/11/30 16:14:24

%% Import the data
[~, ~, raw] = xlsread('/Users/metoo/Documents/experiment/rc/Ensemble RC/GA_RE/GA_RE_v3.0(pass variable)/GA_RE_v3.01(high:low_fix)/weather.xlsx','Sheet1');
raw = raw(2:end,[2:3,5,7:10]);

%% Create output variable
weather = reshape([raw{:}],size(raw));

%% Clear temporary variables
clearvars raw;