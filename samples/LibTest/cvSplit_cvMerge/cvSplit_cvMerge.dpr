// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cvSplit_cvMerge;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
{$I ..\..\uses_include.inc}
  ;

const
  filename = 'Resource\cat2.jpg';

Var
  image: pIplImage = nil;
  gray: pIplImage = nil;
  dst: pIplImage = nil;
  dst2: pIplImage = nil;
  // ��� �������� ��������� ���� RGB-�����������
  r: pIplImage = nil;
  g: pIplImage = nil;
  b: pIplImage = nil;
  temp: pIplImage = nil;

  t1, t2, t3: pIplImage; // ��� �������������� ��������

begin
try
  // �������� ��������
  image := cvLoadImage(filename, 1);
  WriteLn(Format('[i] image: %s', [filename]));

  // ������� �����������
  cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
  cvShowImage('original', image);

  // �������� ��� �������� ����������� � ��������� ������
  gray := cvCreateImage(cvGetSize(image), image^.depth, 1);

  // ����������� �������� � �������� ������
  cvConvertImage(image, gray, CV_BGR2GRAY);

  // ������� ����� ��������
  cvNamedWindow('gray', 1);
  cvShowImage('gray', gray);

  dst := cvCreateImage(cvGetSize(gray), IPL_DEPTH_8U, 1);
  dst2 := cvCreateImage(cvGetSize(gray), IPL_DEPTH_8U, 1);

  // ��������� �������������� ��� ��������� � ��������� ������
  cvThreshold(gray, dst, 50, 250, CV_THRESH_BINARY);
  cvAdaptiveThreshold(gray, dst2, 250, CV_ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY, 7, 1);

  // ���������� ����������
  cvNamedWindow('cvThreshold', 1);
  cvShowImage('cvThreshold', dst);
  cvNamedWindow('cvAdaptiveThreshold', 1);
  cvShowImage('cvAdaptiveThreshold', dst2);

  // :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
  //
  // ������� ��������� �������������� ��� RGB-���������
  //

  r := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
  g := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
  b := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);

  // ��������� �� ��������� ����
  cvSplit(image, b, g, r, 0);

  // �������� ��� �������� ������������� �����������
  temp := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);

  // ���������� �������� � ���������� �����
  cvAddWeighted(r, 1.0 / 3.0, g, 1.0 / 3.0, 0.0, temp);
  cvAddWeighted(temp, 2.0 / 3.0, b, 1.0 / 3.0, 0.0, temp);

  // ��������� ��������� ��������������
  cvThreshold(temp, dst, 50, 250, CV_THRESH_BINARY);

  cvReleaseImage(&temp);

  // ���������� ���������
  cvNamedWindow('RGB cvThreshold', 1);
  cvShowImage('RGB cvThreshold', dst);

  //
  // ��������� ��������� �������������� ��� ���������� ������
  //

  t1 := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
  t2 := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
  t3 := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);

  // ��������� ��������� ��������������
  cvThreshold(r, t1, 50, 250, CV_THRESH_BINARY);
  cvThreshold(g, t2, 50, 250, CV_THRESH_BINARY);
  cvThreshold(b, t3, 50, 250, CV_THRESH_BINARY);

  // ���������� ����������
  cvMerge(t3, t2, t1, 0, image);

  cvNamedWindow('RGB cvThreshold 2', 1);
  cvShowImage('RGB cvThreshold 2', image);

  cvReleaseImage(&t1);
  cvReleaseImage(&t2);
  cvReleaseImage(&t3);

  // :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=

  // ��� ������� �������
  cvWaitKey(0);

  // ����������� �������
  cvReleaseImage(image);
  cvReleaseImage(gray);
  cvReleaseImage(dst);
  cvReleaseImage(dst2);
  cvReleaseImage(r);
  cvReleaseImage(g);
  cvReleaseImage(b);
  // ������� ����
  cvDestroyAllWindows();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
