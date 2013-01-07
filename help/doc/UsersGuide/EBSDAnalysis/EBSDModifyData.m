%% Modify EBSD Data
% How to correct EBSD data for measurement errors.
%
%% Open in Editor
%
%% Contents
%
%%
% First, let us import some example <mtexdata.html EBSD data> and plot
% the raw data

mtexdata aachen;
plot(ebsd)

%%
% These data consist of two indexed phases, _Iron_ and _Magnesium_ : The not
% indexed data is called phase _not Indexed_. They can be visualized by a
% spatial phase plot

close, plot(ebsd,'property','phase')

%% Selecting certain phases
% The data coresponding to a certain phase can be extracted by

ebsd_Fe = ebsd('Fe')

%%
% In order to extract a couple of phases, the mineral names have to be
% grouped in curled parethesis.

ebsd({'Fe','Mg'})

%%
% As an example, let us plot only all not indexed data

close, plot(ebsd('notIndexed'),'facecolor','r')

%% See also
% EBSD/subsref EBSD/subsasgn
%

%% Restricting to a region of interest
% If one is not interested in the whole data set but only in those
% measurements inside a certain polygon, the restriction can be constructed
% as follows:

%%
% First define a region by [xmin ymin xmax-xmin ymax-ymin]

region = [120 100 80 30];

%%
% plot the ebsd data together with the region of interest

close, plot(ebsd)
rectangle('position',region,'edgecolor','r','linewidth',2)

%%
% In order to restrict the ebsd data to the polygon we may use the command
% <EBSD.inpolygon.html inpolygon> to locate all EBSD data inside the region

ebsd = ebsd(inpolygon(ebsd,[120 100 200 130]))


%%
% plot

close, plot(ebsd)

%% Remove Inaccurate Orientation Measurements
%
% *By MAD (mean angular deviation)* in the case of Oxford Channel programs, or *by
% CI (Confidence Index)* in the case of OIM-TSL programs
%
% Most EBSD measurements contain quantities indicating inaccurate
% measurements. 

close, plot(ebsd,'property','mad')

% or

close, plot(ebsd,'property','bc')

%%
% Here we will use the MAD or CI value to identify and eliminate
% inaccurate measurements.

% extract the quantity mad 
mad = get(ebsd,'mad');

%or
% % extract the quantity ci 
bc = get(ebsd,'bc');

% plot a histogram
close, hist(mad)

%or
% plot a histogram
close, hist(bc)


%%

% take only those measurements with MAD smaller then one
ebsd_corrected = ebsd(mad<1)

% take only those measurements with CI higher then 0.1 or 0.2
ebsd_corrected = ebsd(bc>0.1 )

%%
%

close, plot(ebsd_corrected)


