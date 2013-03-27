// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_CvtPixToPlane;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  core_c in '..\..\include\�ore\core_c.pas',
  Core.types_c in '..\..\include\�ore\Core.types_c.pas',
  highgui_c in '..\..\include\highgui\highgui_c.pas',
  imgproc.types_c in '..\..\include\imgproc\imgproc.types_c.pas',
  imgproc_c in '..\..\include\imgproc\imgproc_c.pas',
  LibName in '..\..\include\LibName.pas';

const
  filename = 'Resource\roulette-wheel2-small.jpg';

Var
  image: pIplImage = nil;
  dst: pIplImage = nil;

  // ��� �������� ������� HSV
  hsv: pIplImage = nil;
  h_plane: pIplImage = nil;
  s_plane: pIplImage = nil;
  v_plane: pIplImage = nil;
  // ��� �������� ������� HSV ����� ��������������
  h_range: pIplImage = nil;
  s_range: pIplImage = nil;
  v_range: pIplImage = nil;
  // ��� �������� ��������� ��������
  hsv_and: pIplImage = nil;

  Hmin: Integer = 0;
  Hmax: Integer = 256;

  Smin: Integer = 0;
  Smax: Integer = 256;

  Vmin: Integer = 0;
  Vmax: Integer = 256;

  HSVmax: Integer = 256;

  //
  // �������-����������� ���������
  //
procedure myTrackbarHmin(pos: Integer); cdecl;
begin
  Hmin := pos;
  cvInRangeS(h_plane, cvScalar(Hmin), cvScalar(Hmax), h_range);
end;

procedure myTrackbarHmax(pos: Integer); cdecl;
begin
  Hmax := pos;
  cvInRangeS(h_plane, cvScalar(Hmin), cvScalar(Hmax), h_range);
end;

procedure myTrackbarSmin(pos: Integer); cdecl;
begin
  Smin := pos;
  cvInRangeS(s_plane, cvScalar(Smin), cvScalar(Smax), s_range);
end;

procedure myTrackbarSmax(pos: Integer); cdecl;
begin
  Smax := pos;
  cvInRangeS(s_plane, cvScalar(Smin), cvScalar(Smax), s_range);
end;

procedure myTrackbarVmin(pos: Integer); cdecl;
begin
  Vmin := pos;
  cvInRangeS(v_plane, cvScalar(Vmin), cvScalar(Vmax), v_range);
end;

procedure myTrackbarVmax(pos: Integer); cdecl;
begin
  Vmax := pos;
  cvInRangeS(v_plane, cvScalar(Vmin), cvScalar(Vmax), v_range);
end;

Var
  framemin, framemax: Double;
  c: Integer;

begin

  // �������� ��������
  image := cvLoadImage(filename, 1);
  WriteLn(Format('[i] image: %s', [filename]));

  // ������ ��������
  hsv := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 3);
  h_plane := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
  s_plane := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
  v_plane := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
  h_range := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
  s_range := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
  v_range := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
  hsv_and := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
  // ������������ � HSV
  cvCvtColor(image, hsv, CV_BGR2HSV);
  // ��������� �� �������� ������
  cvCvtPixToPlane(hsv, h_plane, s_plane, v_plane, 0);

  //
  // ���������� ����������� � ������������ ��������
  // � ������� HSV
  framemin := 0;
  framemax := 0;

  cvMinMaxLoc(h_plane, @framemin, @framemax);
  WriteLn(Format('[H] %f x %f', [framemin, framemax]));
  Hmin := Trunc(framemin);
  Hmax := Trunc(framemax);
  cvMinMaxLoc(s_plane, @framemin, @framemax);
  WriteLn(Format('[S] %f x %f', [framemin, framemax]));
  Smin := Trunc(framemin);
  Smax := Trunc(framemax);
  cvMinMaxLoc(v_plane, @framemin, @framemax);
  WriteLn(Format('[V] %f x %f', [framemin, framemax]));
  Vmin := Trunc(framemin);
  Vmax := Trunc(framemax);

  // ���� ��� ����������� ��������
  cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
  cvNamedWindow('H', CV_WINDOW_AUTOSIZE);
  cvNamedWindow('S', CV_WINDOW_AUTOSIZE);
  cvNamedWindow('V', CV_WINDOW_AUTOSIZE);
  cvNamedWindow('H range', CV_WINDOW_AUTOSIZE);
  cvNamedWindow('S range', CV_WINDOW_AUTOSIZE);
  cvNamedWindow('V range', CV_WINDOW_AUTOSIZE);
  cvNamedWindow('hsv and', CV_WINDOW_AUTOSIZE);

  cvCreateTrackbar('Hmin', 'H range', @Hmin, HSVmax, myTrackbarHmin);
  cvCreateTrackbar('Hmax', 'H range', @Hmax, HSVmax, myTrackbarHmax);
  cvCreateTrackbar('Smin', 'S range', @Smin, HSVmax, myTrackbarSmin);
  cvCreateTrackbar('Smax', 'S range', @Smax, HSVmax, myTrackbarSmax);
  cvCreateTrackbar('Vmin', 'V range', @Vmin, HSVmax, myTrackbarVmin);
  cvCreateTrackbar('Vmax', 'V range', @Vmax, HSVmax, myTrackbarVmax);

  //
  // ��������� ���� �� �������� �����
  //
  if (image^.width < 1920 / 4) and (image^.height < 1080 / 2) then
  begin
    cvMoveWindow('original', 0, 0);
    cvMoveWindow('H', image^.width + 10, 0);
    cvMoveWindow('S', (image^.width + 10) * 2, 0);
    cvMoveWindow('V', (image^.width + 10) * 3, 0);
    cvMoveWindow('hsv and', 0, image^.height + 30);
    cvMoveWindow('H range', image^.width + 10, image^.height + 30);
    cvMoveWindow('S range', (image^.width + 10) * 2, image^.height + 30);
    cvMoveWindow('V range', (image^.width + 10) * 3, image^.height + 30);
  end;

  while true do
  begin

    // ���������� ��������
    cvShowImage('original', image);

    cvShowImage('H', h_plane);
    cvShowImage('S', s_plane);
    cvShowImage('V', v_plane);

    cvShowImage('H range', h_range);
    cvShowImage('S range', s_range);
    cvShowImage('V range', v_range);

    // ����������
    cvAnd(h_range, s_range, hsv_and);
    cvAnd(hsv_and, v_range, hsv_and);

    cvShowImage('hsv and', hsv_and);

    c := cvWaitKey(33);
    if (c = 27) then // ���� ������ ESC - �������
      break;
  end;

  WriteLn('[i] Results:');
  WriteLn(Format('[H] %d x %d', [Hmin, Hmax]));
  WriteLn(Format('[S] %d x %d', [Smin, Smax]));
  WriteLn(Format('[V] %d x %d', [Vmin, Vmax]));

  // ����������� �������
  cvReleaseImage(image);
  cvReleaseImage(hsv);
  cvReleaseImage(h_plane);
  cvReleaseImage(s_plane);
  cvReleaseImage(v_plane);
  cvReleaseImage(h_range);
  cvReleaseImage(s_range);
  cvReleaseImage(v_range);
  cvReleaseImage(hsv_and);
  // ������� ����
  cvDestroyAllWindows();

end.
