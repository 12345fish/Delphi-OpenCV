program cvSubDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  core_c in '..\..\include\�ore\core_c.pas',
  Core.types_c in '..\..\include\�ore\Core.types_c.pas',
  highgui_c in '..\..\include\highgui\highgui_c.pas',
  imgproc.types_c in '..\..\include\imgproc\imgproc.types_c.pas',
  imgproc_c in '..\..\include\imgproc\imgproc_c.pas';

const
  filename = 'cat2.jpg';

Var
  src: pIplImage = nil;
  dst: pIplImage = nil;
  dst2: pIplImage = nil;

begin
  // �������� �������� � ��������� ������
  src := cvLoadImage(filename, CV_LOAD_IMAGE_GRAYSCALE);
  WriteLn(Format('[i] image: %s', [filename]));

  // ������� �����������
  cvNamedWindow('original', 1);
  cvShowImage('original', src);

  // ������� �������� �����������
  dst2 := cvCreateImage(cvSize(src^.width, src^.height), IPL_DEPTH_8U, 1);
  cvCanny(src, dst2, 50, 200);

  cvNamedWindow('bin', 1);
  cvShowImage('bin', dst2);

  // cvScale(src, dst);
  cvSub(src, dst2, dst2);
  cvNamedWindow('sub', 1);
  cvShowImage('sub', dst2);

  // ��� ������� �������
  cvWaitKey(0);

  // ����������� �������
  cvReleaseImage(src);
  cvReleaseImage(dst);
  cvReleaseImage(dst2);
  // ������� ����
  cvDestroyAllWindows();

end.
