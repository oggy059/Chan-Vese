function varargout = interface(varargin)
addpath('function');
addpath('interface');
%INTERFACE M-file for interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to interface_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      INTERFACE('CALLBACK') and INTERFACE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in INTERFACE.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface

% Last Modified by GUIDE v2.5 01-Apr-2016 13:52:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before interface is made visible.
function interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function filter_Callback(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function binary_Callback(hObject, eventdata, handles)
% hObject    handle to binary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --------------------------------------------------------------------
function viewer_3D_Callback(hObject, eventdata, handles)
% hObject    handle to viewer_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 3D viewer
Viewer_3D;

% --------------------------------------------------------------------
function mesure_3D_Callback(hObject, eventdata, handles)
% hObject    handle to mesure_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 addpath('function/imMinkowski');
 imeasurementInterface;


% --------------------------------------------------------------------
function analyse_squelette_3D_Callback(hObject, eventdata, handles)
% hObject    handle to analyse_squelette_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% 3D skeleton analysis

stackpath = SkelAnalysisInterface();

if isempty(stackpath)
         return
end

Files = dir(strcat(stackpath,'*.tif'));
LengthFiles = length(Files);
Img1 = imread(strcat(stackpath ,Files(1).name));
[h,w]=size(Img1);
skel = zeros(h,w,LengthFiles);

 for i=2:LengthFiles-1
     skel(:,:,i) = logical(imread(strcat(stackpath,Files(i).name)));
 end
 
w = size(skel,1);
l = size(skel,2);
h = size(skel,3);

% convert skeleton to graph structure
addpath('function/Skel2Graph3D');
[A,node,link] = Skel2Graph3D(skel,4);
jonctions = node;

% convert graph structure back to (cleaned) skeleton
skel2 = Graph2Skel3D(node,link,w,l,h);

% iteratively convert until there are no more 2-nodes left
[A2,node2,link2] = Skel2Graph3D(skel2,4);

branches = link2;


resultSkelAnalysis(branches,jonctions);
 


% --------------------------------------------------------------------
function ouverture_Callback(hObject, eventdata, handles)
% hObject    handle to ouverture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set Itmp as undid image 
global Itmp;
global I;
Itmp = I ;

% get the parameters from another fig
[n_iters,count] = OpenOptions();
if isempty(n_iters)||isempty(count)
    return
end

% do the open function to I
se = strel('square',count);% the style is square 
IM2 = imopen(I,se);
for j=1:n_iters-1
    IM2 = imopen(IM2,se);
end

% showing result as IM2
axes(handles.axes4);
imshow(IM2);

axes(handles.pic1);
imshow(Itmp);

% show comment and related parameters
set(handles.resultcomment, 'Visible','on');
set(handles.text25,'Visible','on');

global comment;
set(handles.resultcomment,'string',comment);
set(handles.text25,'string',['Open_n=',sprintf('%03d',n_iters),'_c=',sprintf('%03d',count)]);

% assign the result IM2 to I
I = IM2;


% --------------------------------------------------------------------
function fermeture_Callback(hObject, eventdata, handles)
% hObject    handle to fermeture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set Itmp as undid image 
global Itmp;
global I;
Itmp = I ;

% get parameters
[n_iters,count] = CloseOptions();
if isempty(n_iters)||isempty(count)
    return
end

% do the close function to I
se = strel('square',count);
Iclose = imclose(I,se);
for j=1:n_iters-1
    Iclose = imclose(Iclose,se);
end

% showing result as Iclose
axes(handles.axes4);
imshow(Iclose);

axes(handles.pic1);
imshow(Itmp);

% show the related parameters and comment

set(handles.resultcomment, 'Visible','on');
set(handles.text25,'Visible','on');

global comment;
set(handles.resultcomment,'string',comment);
set(handles.text25,'string',['Close_n=',sprintf('%01d',n_iters),'_c=',sprintf('%01d',count)]);


% assign the result Iclose to I
I = Iclose;

% --------------------------------------------------------------------
%Filling holes function
function fill_h_Callback(hObject, eventdata, handles)
% hObject    handle to fill_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set Itmp as undid image 
global Itmp;
global I;
Itmp = I ;

% get parameters from anther fig
n_iters = FillHolesOptions();
if isempty(n_iters)|| isequal(n_iters,0)
    return
end

% do the fill holes function to I
IF = imfill(I,'holes');
for j=1:n_iters-1
    IF = imfill(IF,'holes');
end

% show result as IF
axes(handles.axes4);
imshow(IF);

axes(handles.pic1);
imshow(Itmp);
% show the related parameters and comment
set(handles.resultcomment, 'Visible','on');
set(handles.text25,'Visible','on');

global comment;
set(handles.resultcomment,'string',comment);
set(handles.text25,'string',['Fill-holes_n=',sprintf('%01d',n_iters)]);


% assign the result Iclose to I
I = IF;

% --------------------------------------------------------------------
%Image inversion function
function inverse_Callback(hObject, eventdata, handles)
% hObject    handle to inverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Itmp;
global I;
Itmp = I;

I = (~I);
axes(handles.pic1);
imshow(Itmp);

axes(handles.axes4);
imshow(I);

% show the related parameters and comment
set(handles.resultcomment, 'Visible','on');
set(handles.text25,'Visible','on');

global comment;
set(handles.resultcomment,'string',comment);
set(handles.text25,'string',['Image after inversing']);



% --------------------------------------------------------------------
%Manual segmentation function
function seg_m_Callback(hObject, eventdata, handles)
% hObject    handle to seg_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set Itmp as undid image 

global I;
global Itmp;
Itmp = I;

% proceed the manuel segmentation on pic1
axes(handles.pic1);
sz = size(I);
totMask = false( sz ); % accumulate all single object masks to this one
h = imfreehand( gca ); setColor(h,'red');
position = wait( h );
BW = createMask( h );
totMask = totMask | BW;

while(strcmp( seg_manuel(),'Yes' ) == true)

      h = imfreehand( gca ); setColor(h,'red');
      position = wait( h );
      BW = createMask( h );
      totMask = totMask | BW; % add mask to global mask
 
end

cla reset
imshow(I);

% show the result in axes 4
axes(handles.axes4);
imshow(totMask);
I = totMask;

axes(handles.pic1);
imshow(Itmp);

% set result comment
global comment;
global filename;
comment = ['seg_Manuel_',filename];
set(handles.resultcomment,'string',comment);
set(handles.resultcomment,'Visible','on');


% --------------------------------------------------------------------
function seg_o_Callback(hObject, eventdata, handles)
% hObject    handle to seg_o (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set Itmp as undid image 
global I; 
global Itmp;
Itmp = I;

% Otsu
level = graythresh(I);
value = level * 255;
BW = im2bw(I,level);

%showing the Otsu result as BW
axes(handles.axes4);
imshow(BW);

axes(handles.pic1);
imshow(Itmp);

% show the comment and related parameters
set(handles.resultcomment,'Visible','on');
set(handles.text25,'Visible','on');
global comment;
global filename;
comment = ['seg_Otsu_S=',sprintf('%04d',value),'_',filename];
set(handles.resultcomment,'string',comment);
set(handles.text25,'string',['Seuil = ',sprintf('%04d',value)]);

% assign the BW to I
I = BW;

% --------------------------------------------------------------------
function seg_cv3d_Callback(hObject, eventdata, handles)
% hObject    handle to seg_cv3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[cancel, Mask_pathname,Sweight,Iweight] = Seg_ChanVese3D();
if (cancel == 0)
    return
end

if isempty(Mask_pathname)||isempty(Sweight)||isempty(Iweight)
    return
end
global inpn;
Files = dir(strcat(inpn,'*.tif'));
im1 = imread(Files(1).name);
sizeimage = size(im1);
Filematrix = zeros(sizeimage(1),sizeimage(2),length(Files));
for i = 1:length(Files)
    Filematrix(:,:,i) = im2double(imread(Files(i).name));
end
MaskFiles = dir(strcat(Mask_pathname,'*.tif'));
Maskmatrix = zeros(sizeimage(1),sizeimage(2),length(MaskFiles));
for i = 1:length(MaskFiles)
    Maskmatrix(:,:,i) = im2double(imread(MaskFiles(i).name));
end

phi = ac_reinit(Maskmatrix-.5); 
phi = ac_ChanVese_model(Filematrix, phi, Sweight, Iweight, 1, 100); 

%%
mkdir('result_of_cv3d');
SIZE = size(phi);
for i = 1:SIZE(3);
 %IOUT = imresize(phi(:,:,i),[h,w]);
 imwrite(phi(i),['result_of_cv3d/Result_of_chanvese3d_w1=',sprintf('%03d',Sweight),'_w2=',sprintf('%03d',Iweight),'_',Files(i).name],'tiff');
end
inpn = [pwd,'result_of_cv3d'];


% --------------------------------------------------------------------
function median_f_Callback(hObject, eventdata, handles)
% hObject    handle to median_f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set Itmp as undid image 
global Itmp;
global I;
Itmp = I ;

% get the radius of median filter from another figure
radius = str2num(interfacemedian());
if isempty(radius)
    return
end 


% filter the image I
Mdi = medfilt2(I,[radius radius]);

% showing result image on pic1 
axes(handles.pic1);
imshow(Mdi);

% show the related parameters and comment

[W H] = size(Mdi);
resolution = strcat(num2str(W),' x ',num2str(H));
set(handles.text8, 'string',resolution);
file= get(handles.text7, 'string');
file = strcat('median filtered radius=',num2str(radius),'_',file);
set(handles.text7, 'string',file);

% assign the result Mdi to I
I = Mdi;

% --------------------------------------------------------------------
function undo_Callback(hObject, eventdata, handles)
% hObject    handle to undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Itmp;
global I;
I = Itmp;

set(handles.resultcomment,'Visible','off');
set(handles.text25,'Visible','off');
axes(handles.axes4);
cla reset

axes(handles.pic1);
imshow(I);


% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.resultcomment,'Visible','off');
set(handles.text25,'Visible','off');
axes(handles.axes4);
cla reset

global filename;
[filename,pathname ] = uigetfile({'*.tif'},'File Selector');
if isequal(filename,0) || isequal(pathname,0)
    return
end

set(handles.text7, 'string',filename);
global inpn;

inpn = strcat(pathname,filename);

imSrc = im2double(imread(strcat(pathname,filename)));

% showing input image imSrc
axes(handles.pic1);
imshow(imSrc);
[W H] = size(imSrc);
resolution = strcat(num2str(W),' x ',num2str(H));
set(handles.text8, 'string',resolution);

%assign the imSrc to I
global I;
I = imSrc;


% --------------------------------------------------------------------
function import_stack_Callback(hObject, eventdata, handles)
% hObject    handle to import_stack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.resultcomment,'Visible','off');
set(handles.text25,'Visible','off');
axes(handles.axes4);
cla reset

%import all the images in one folder

[directoryname,ic_pathname,ic_filename] = importstack();

if isempty(directoryname)|| isempty(ic_pathname)|| isempty(ic_filename)
     return
end
global inpn;
inpn = directoryname;
directoryname1 = strcat(inpn,'/');
Files = dir(strcat(directoryname1,'*.tif'));
LengthFiles = length(Files);


global originaldirectory;
originaldirectory = directoryname;

% showing central image dans axes1
global indexcenter;
Icentrale = im2double(imread([ic_pathname,ic_filename]));
for i=1:LengthFiles
    if isequal(ic_filename,Files(i).name)
        indexcenter = i;
        break
    end
end
set(handles.text7, 'string',['central image ',Files(indexcenter).name]);
axes(handles.pic1);
imshow(Icentrale);

[W H] = size(Icentrale);
resolution = strcat(num2str(W),' x ',num2str(H));
set(handles.text8, 'string',resolution);

% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global I;
global inpn;
imwrite(I,inpn,'TIFF');

% --------------------------------------------------------------------
function save_a_Callback(hObject, eventdata, handles)
% hObject    handle to save_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global comment;

[filename, pathname] = uiputfile({ '*.tif','Tiff File (*.)'}, ... 
        'Save picture as',comment);
if isequal(filename,0) || isequal(pathname,0)
    return
end

global I;global inpn;
imwrite(I,strcat(pathname,filename),'TIFF');
inpn = strcat(pathname,filename);


% --------------------------------------------------------------------
function save_stack_Callback(hObject, eventdata, handles)
% hObject    handle to save_stack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originaldirectory;
global inpn;
Files = dir(strcat(inpn,'*.tif'));
for i = 1:length(Files)
    imwrite(imread(Files(i).name),[originaldirectory,Files(i).name],'tiff','Compression','none');
       
end



% --------------------------------------------------------------------
function save_stack_as_Callback(hObject, eventdata, handles)
% hObject    handle to save_stack_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directoryname = uigetdir;
if isequal(directoryname,0)
    return
end

global inpn;
Files = dir(strcat(inpn,'*.tif'));
for i = 1:length(Files)
    imwrite(imread(Files(i).name),[directoryname,Files(i).name],'tiff','Compression','none');
       
end

% --------------------------------------------------------------------
function uipushtoolopen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtoolopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.resultcomment,'Visible','off');
set(handles.text25,'Visible','off');
axes(handles.axes4);
cla reset

global filename;
[filename,pathname ] = uigetfile({'*.tif'},'File Selector');
if isequal(filename,0) || isequal(pathname,0)
    return
end

set(handles.text7, 'string',filename);
global inpn;

inpn = strcat(pathname,filename);

imSrc = im2double(imread(strcat(pathname,filename)));

% showing input image imSrc
axes(handles.pic1);
imshow(imSrc);
[W H] = size(imSrc);
resolution = strcat(num2str(W),' x ',num2str(H));
set(handles.text8, 'string',resolution);

%assign the imSrc to I
global I;
I = imSrc;

% --------------------------------------------------------------------
function uipushtoolsave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtoolsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global I;
global inpn;
imwrite(I,inpn,'TIFF');


% --------------------------------------------------------------------
function seg_cv2d_Callback(hObject, eventdata, handles)
% hObject    handle to seg_cv2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set Itmp as undid image 
global I;
global Itmp;
Itmp = I;

% return the mask's pathname and three parameters for chanvese 2d
[mask_pathname sweight iweight iterations] = interface_chanvese2d();
if isempty(mask_pathname)|| isempty(sweight)|| isempty(iweight)|| isempty(iterations)
     return
end

% open the mask for chanese 2d
mask = im2double(imread(mask_pathname));
phi = ac_reinit(mask -.5); % phi initial
% proceed the Chan-Vese 2d segmentation on I
IC = I;
phic = ac_ChanVese_model(IC, phi, sweight, iweight, ...
    1, iterations, 1);

% show the result image on axes 4
axes(handles.axes4);
imshow(phic);

axes(handles.pic1);
imshow(Itmp);

% show the comment and related parameters
set(handles.resultcomment,'Visible','on');
set(handles.text25,'Visible','on');

global comment;
global filename;
comment = ['seg_Chan-Vese2d_sw=',sprintf('%04d',sweight),'_iw=',sprintf('%04d',iweight),'_',filename];
set(handles.resultcomment,'string',comment);

set(handles.text25, 'string',['sw=',sprintf('%04d',sweight),'_iw=',sprintf('%04d',iweight)]);

% assign phic to I
I = phic;


% --------------------------------------------------------------------
% Chan-Vese 2.5D segmentation function
% Segment a serie of images using the same mask
function seg_cv25d_Callback(hObject, eventdata, handles)
% hObject    handle to seg_cv25d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Directory path to the stack images
% global inpn;
% Files = dir(strcat(inpn,'*.tif'));
% LengthFiles = length(Files);

%Directory path to the stack images
global inpn;
% Files = dir(strcat(inpn,'*.tif'));

directoryname1 = strcat(inpn,'/');
Files = dir(strcat(directoryname1,'*.tif'));
directoryname2 = strcat(inpn,'\New/');
Files2 = dir(strcat(directoryname2,'*.tif'));
File = [Files;Files2];
LengthFiles = length(File);

%Select the mask image
global indexcenter;
Icentrale = im2double(imread(strcat(directoryname1,Files(indexcenter).name)));
[cancel,mask_pathname,sw1,sw2,iw] = Seg_CV3D(Icentrale);

if(cancel == 0)
    
    if isempty(mask_pathname)|| isempty(sw1)|| isempty(iw)|| isempty(sw2)
         return
    end
    
    mkdir('result_of_CV25D');%create the folder for the result images
    mask = im2double(imread(mask_pathname));
    phi = ac_reinit(mask -.5); % phi initial
  
    
    % proceed the Chan-Vese 2d segmentation on central image and show it on the
    % axes4

    IC = Icentrale;
    IC = medfilt2(IC,[3,3]);%filter the central image using median filter
 

    % chanvese sw = 150 iw = 150       
        try
            phi1 = ac_ChanVese_model(IC, phi, sw1, iw, 1, 50, 0);
            catch ME
                disp(['image cannot segmented phi1 =',sprintf('%03d',sw1)]);
                disp(Files(indexcenter).name);
                phi1 = zeros(size(phi));
        end
        imwrite(phi1,'result/phi1.tif','tiff');
    
    % chanvese sw = 30, iw = 150
        try
            phi2 = ac_ChanVese_model(IC, phi, sw2, iw,1, 50, 0);
            catch ME
                disp(['image cannot segmented phi2 =',sprintf('%03d',sw2)]);
                disp(Files(indexcenter).name);
                phi2 = zeros(size(phi));
        end
        imwrite(phi2,'result/phi2.tif','tiff');
          
        phi1 = imread('result/phi1.tif');
        phi2 = imread('result/phi2.tif');
        phic = or (phi1, phi2);%fusion both images
            
    

    % show the result image on axes 4
    axes(handles.axes4);
    imshow(phic);
    imwrite(phic,['result_of_CV25D/Result_of_CV25D_sw1=',sprintf('%03d',sw1),'_sw2=',sprintf('%03d',sw2),'_iw=',sprintf('%03d',iw),'_',Files(indexcenter).name],'tiff','Compression','none');




%% up -i
%     mask = phic;
    for i = 1:indexcenter-1    
    
        II= im2double(imread([directoryname1,Files(indexcenter-i).name]));
        II = medfilt2(II,[3,3]);
        phi = ac_reinit(mask -.5);
        
        ME_phi1 = 0;
        ME_phi2 = 0;
        
    % chanvese sw = 150 iw = 150       
        try
            phi1 = ac_ChanVese_model(II, phi, sw1, iw,1, 50, 0);
            catch ME
                ME_phi1 = 1;
                disp(['image cannot segmented phi1 =',sprintf('%03d',sw1)]);
                disp(Files(indexcenter-i).name);
                phi1 = zeros(size(phi));
        end
        imwrite(phi1,'result/phi1.tif','tiff');
    
    % chanvese sw = 30, iw = 150
        try
            phi2 = ac_ChanVese_model(II, phi, sw2, iw,1, 50, 0);
        catch ME
                ME_phi2 = 1;
                disp(['image cannot segmented phi2 =',sprintf('%03d',sw2)]);
                disp(Files(indexcenter-i).name);
                phi2 = zeros(size(phi));
        end
        imwrite(phi2,'result/phi2.tif','tiff');
        
        
    
        if(ME_phi1 == 1 && ME_phi2 == 1)
            break
        end
    
        
        phi1 = imread('result/phi1.tif');
        phi2 = imread('result/phi2.tif');
        phi = or (phi1, phi2);
    
        imwrite(phi,['result_of_CV25D/Result_of_CV25D_sw1=',sprintf('%03d',sw1),'_sw2=',sprintf('%03d',sw2),'_iw=',sprintf('%03d',iw),'_',Files(indexcenter-i).name],'tiff','Compression','none');
%         mask = phi;
    
    end



%% down
%     mask = phic;
    
    for i = indexcenter+1:LengthFiles 
        ME_phi1 = 0;
        ME_phi2 = 0;
        if i > 999,
        	II= im2double(imread(strcat(directoryname2,File(i).name)));
        else
            II= im2double(imread(strcat(directoryname1,File(i).name)));
        end;
        II = medfilt2(II,[3,3]);
        phi = ac_reinit(mask -.5); 
            
    % chanvese sw = 150 iw = 150       
        try
            phi1 = ac_ChanVese_model(II, phi, sw1, iw,1, 50, 0);
            catch ME
                ME_phi1 = 1;
                disp(['image cannot segmented phi1 =',sprintf('%03d',sw1)]);
                disp(File(i).name);
                phi1 = zeros(size(phi));
        end
        imwrite(phi1,'result/phi1.tif','tiff');
    
    % chanvese sw = 30, iw = 150
        try
            phi2 = ac_ChanVese_model(II, phi, sw2, iw, 1, 50, 0);
        catch ME
                ME_phi2 = 1;
                disp(['image cannot segmented phi2 =',sprintf('%03d',sw2)]);
                disp(File(i).name);
                phi2 = zeros(size(phi));
        end
        imwrite(phi2,'result/phi2.tif','tiff');
            
        if(ME_phi1 == 1 && ME_phi2 == 1)
            break
        end
            
        phi1 = imread('result/phi1.tif');
        phi2 = imread('result/phi2.tif');
        phi = or (phi1, phi2);
        
        imwrite(phi,['result_of_CV25D/Result_of_CV25D_sw1=',sprintf('%03d',sw1),'_sw2=',sprintf('%03d',sw2),'_iw=',sprintf('%03d',iw),'_',File(i).name],'tiff','Compression','none');
%         mask = phi;
    
    end
    inpn = [pwd,'result_of_cv25D'];
end 


% --------------------------------------------------------------------
function processus_3d_Callback(hObject, eventdata, handles)
% hObject    handle to processus_3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
