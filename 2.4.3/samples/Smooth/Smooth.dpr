program Smooth;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Core.types_c in '..\..\include\�ore\Core.types_c.pas',
  core_c in '..\..\include\�ore\core_c.pas',
  highgui_c in '..\..\include\highgui\highgui_c.pas',
  imgproc.types_c in '..\..\include\imgproc\imgproc.types_c.pas',
  imgproc_c in '..\..\include\imgproc\imgproc_c.pas';

Const
  // ��� ��������
  filename = 'opencv_logo_with_text.png';

Var
  image: PIplImage = nil;
  dst: PIplImage = nil;

begin
  try
    // �������� ��������
    image := cvLoadImage(filename, 1);
    // ��������� ��������
    dst := cvCloneImage(image);
    Writeln('[i] image: ', filename);
    if not Assigned(image) then
      Halt;
    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('Smooth', CV_WINDOW_AUTOSIZE);
    // ���������� �������� ��������
//    cvSmooth(image, dst, CV_GAUSSIAN, 3, 3);
    cvSmooth(image, dst, CV_BLUR_NO_SCALE, 3, 3);
    // ���������� ��������
    cvShowImage('original', image);
    cvShowImage('Smooth', dst);
    // ��� ������� �������
    cvWaitKey(0);
    // ����������� �������
    cvReleaseImage(&image);
    cvReleaseImage(&dst);
    // ������� ����
    cvDestroyWindow('original');
    cvDestroyWindow('Smooth');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
