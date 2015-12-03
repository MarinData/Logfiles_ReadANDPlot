clc;clear;close all
% made by Fredrik Dukan, 3 Dec 2010
% revision, 19 January 2011
% m-file for reading logfiles from December 2010 cruise with ROV Minerva
%% read data

%INPUT:-------------------------
file_n='log5';
%END INPUT------------------------

path_c=cd;
sel_path=[path_c,'/',file_n,'.txt'];

[rawTime,time,SensData,EstStates,DesStates,ControlF,ThrustRPM,raw,pro,do,logInfo]=readLogFile(sel_path); 

%% plot data

logInfo; %write log info to screen

time=rawTime;
north_mes=SensData(:,1);
east_mes=SensData(:,2);
depth_mes=SensData(:,3);
head_mes=SensData(:,4);
north_est=EstStates(:,1);
east_est=EstStates(:,2);
depth_est=EstStates(:,3);
head_est=EstStates(:,4);
north_des=DesStates(:,1);
east_des=DesStates(:,2);
depth_des=DesStates(:,3);
head_des=DesStates(:,4);
alt_mes=SensData(:,9);
alt_est=EstStates(:,13);
alt_des=DesStates(:,9);

clear SensData EstStates DesStates ControlF ThrustRPM raw pro do
fnameWS=strcat(file_n,'.mat');
save(fnameWS)
