program Weighted2;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  core_c in '..\..\include\�ore\core_c.pas',
  Core.types_c in '..\..\include\�ore\Core.types_c.pas',
  highgui_c in '..\..\include\highgui\highgui_c.pas';

Const
  filename_src1 = 'cat2-mirror.jpg';
  filename_src2 = 'cat2.jpg';

Var
  image: pIplImage = nil;
  templ: pIplImage = nil;
  dst: pIplImage = nil;
  x, y, width, height: Integer;
  alpha, beta: Double;

begin
  image := cvLoadImage(filename_src1);
  WriteLn(Format('[i] image_src1: %s', [filename_src1]));
  templ := cvLoadImage(filename_src2);
  WriteLn(Format('[i] image_src2: %s', [filename_src2]));

  cvNamedWindow('origianl', CV_WINDOW_AUTOSIZE);
  cvNamedWindow('template', CV_WINDOW_AUTOSIZE);
  cvNamedWindow('res', CV_WINDOW_AUTOSIZE);
  dst := cvCloneImage(templ);
  // ������ �������
  width := templ^.width;
  height := templ^.height;

  // �������� � ������
  cvShowImage('origianl', image);
  cvShowImage('template', templ);

  x := 0;
  y := 0;
  // ����� ������� ������������
  alpha := 0.5;
  beta := 0.5;
  // ������������� ������� ��������
  cvSetImageROI(image, cvRect(x, y, width, height));
  // ���������� �����
  cvAddWeighted(image, alpha, templ, beta, 0.0, dst);
  // ����������� ������� ��������
  cvResetImageROI(image);
  // ���������� ���������
  cvShowImage('res', dst);

  // ��� ������� �������
  cvWaitKey(0);

  // ����������� �������
  cvReleaseImage(image);
  cvReleaseImage(templ);
  cvReleaseImage(dst);
  cvDestroyAllWindows();

end.
