// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cvErode_cvDilate;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
uLibName in '..\..\..\include\uLibName.pas',
highgui_c in '..\..\..\include\highgui\highgui_c.pas',
core_c in '..\..\..\include\�ore\core_c.pas',
Core.types_c in '..\..\..\include\�ore\Core.types_c.pas',
imgproc.types_c in '..\..\..\include\imgproc\imgproc.types_c.pas',
imgproc_c in '..\..\..\include\imgproc\imgproc_c.pas',
legacy in '..\..\..\include\legacy\legacy.pas',
calib3d in '..\..\..\include\calib3d\calib3d.pas',
imgproc in '..\..\..\include\imgproc\imgproc.pas',
haar in '..\..\..\include\objdetect\haar.pas',
objdetect in '..\..\..\include\objdetect\objdetect.pas',
tracking in '..\..\..\include\video\tracking.pas',
Core in '..\..\..\include\�ore\core.pas'
  ;

Const
  // ��� ��������
  filename = 'Resource\opencv_logo_with_text.png';

Var
  image: PIplImage = Nil;
  dst: PIplImage = Nil;

  erode: PIplImage = Nil;
  dilate: PIplImage = Nil;

  radius: Integer = 1;
  radius_max: Integer = 10;
  iterations: Integer = 1;
  iterations_max: Integer = 10;
  Kern: pIplConvKernel;
  c: Integer;

  //
  // �������-���������� �������� -
  // ������ ����
procedure myTrackbarRadius(pos: Integer); cdecl;
begin
  radius := pos;
end;

//
// �������-���������� �������� -
// ����� ��������
procedure myTrackbarIterations(pos: Integer); cdecl;
begin
  iterations := pos;
end;

begin
  try
    image := cvLoadImage(filename, 1);
    Writeln('[i] image: ', filename);
    if not Assigned(image) then
      Halt;
    // ��������� ��������
    dst := cvCloneImage(image);
    erode := cvCloneImage(image);
    dilate := cvCloneImage(image);
    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('erode', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('dilate', CV_WINDOW_AUTOSIZE);

    cvCreateTrackbar('Radius', 'original', @radius, radius_max, myTrackbarRadius);
    cvCreateTrackbar('Iterations', 'original', @iterations, iterations_max, myTrackbarIterations);

    while True do
    begin
      // ���������� ��������
      cvShowImage('original', image);
      // ������ ����
      Kern := cvCreateStructuringElementEx(radius * 2 + 1, radius * 2 + 1, radius, radius, CV_SHAPE_ELLIPSE);
      // ��������� ��������������
      cvErode(image, erode, Kern, iterations);
      cvDilate(image, dilate, Kern, iterations);
      // ���������� ���������
      cvShowImage('erode', erode);
      cvShowImage('dilate', dilate);
      cvReleaseStructuringElement(Kern);
      c := cvWaitKey(33);
      if (c = 27) then
        Break;
    end;
    // ����������� �������
    cvReleaseImage(image);
    cvReleaseImage(dst);
    cvReleaseImage(erode);
    cvReleaseImage(dilate);
    // ������� ����
    cvDestroyWindow('original');
    cvDestroyWindow('erode');
    cvDestroyWindow('dilate');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
