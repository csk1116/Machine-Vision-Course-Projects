function varargout = EAN13_READER(varargin)
% EAN13_READER MATLAB code for EAN13_READER.fig
%      EAN13_READER, by itself, creates a new EAN13_READER or raises the existing
%      singleton*.
%
%      H = EAN13_READER returns the handle to a new EAN13_READER or the handle to
%      the existing singleton*.
%
%      EAN13_READER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EAN13_READER.M with the given input arguments.
%
%      EAN13_READER('Property','Value',...) creates a new EAN13_READER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EAN13_READER_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EAN13_READER_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EAN13_READER

% Last Modified by GUIDE v2.5 26-Nov-2017 20:13:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EAN13_READER_OpeningFcn, ...
                   'gui_OutputFcn',  @EAN13_READER_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before EAN13_READER is made visible.
function EAN13_READER_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EAN13_READER (see VARARGIN)

% Choose default command line output for EAN13_READER
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EAN13_READER wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EAN13_READER_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in TS.
function TS_Callback(hObject, eventdata, handles)
% hObject    handle to TS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.II);
B = image_browser();
imshow(B);
axes(handles.IL);
BC = locate_barcode(B);
imshow(BC);
axes(handles.BR);
BCM = mean_filter(BC);
BCS = image_sharpening(BCM);
BC = sharpening_level(BCS,BC);
[SRD,SR] = barcode_binary_processing(BC);
imshow(SRD,'parent');
% [LR,RLE] = read_barcode(SR);
% [LHG,LH,~,FST,FSTC,CG,RH,~,RHG,~] = barcode_decoding(LR,RLE);
% [ANS,FST,FSTC,LHG,LHC,CG,RHC,RHG,Error,RHE,LHE]=check_sum_digit(LHG,LH,FST,FSTC,CG,RH,RHG);
% set(handles.TT,'Data',ANS,FST,FSTC,LHG,LHC,CG,RHC,RHG,Error,RHE,LHE);

 
