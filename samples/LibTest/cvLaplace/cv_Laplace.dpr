// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_Laplace;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  core_c in '..\..\..\include\�ore\core_c.pas',
  Core.types_c in '..\..\..\include\�ore\Core.types_c.pas',
  highgui_c in '..\..\..\include\highgui\highgui_c.pas',
  imgproc.types_c in '..\..\..\include\imgproc\imgproc.types_c.pas',
  imgproc_c in '..\..\..\include\imgproc\imgproc_c.pas',
  uLibName in '..\..\..\include\uLibName.pas',
  types_c in '..\..\..\include\�ore\types_c.pas';

const
  filename = 'Resource\cat2.jpg';

Var
  image: pIplImage = Nil;
  dst: pIplImage = Nil;
  dst2: pIplImage = Nil;
  aperture: Integer = 3;

begin

  // �������� ��������
  image := cvLoadImage(filename);
  WriteLn(Format('[i] image: %s', [filename]));
  // ������ ��������
  dst := cvCreateImage(cvGetSize(image), IPL_DEPTH_16S, image^.nChannels);
  dst2 := cvCreateImage(cvGetSize(image), image^.depth, image^.nChannels);

  // ���� ��� ����������� ��������
  cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
  cvNamedWindow('cvLaplace', CV_WINDOW_AUTOSIZE);

  // ��������� �������� �������
  cvLaplace(image, dst, aperture);

  // ����������� ����������� � 8-�������
  cvConvertScale(dst, dst2);

  // ���������� ��������
  cvShowImage('original', image);
  cvShowImage('cvLaplace', dst2);

  cvWaitKey(0);

  // ����������� �������
  cvReleaseImage(image);
  cvReleaseImage(dst);
  cvReleaseImage(dst2);
  // ������� ����
  cvDestroyAllWindows();

end.
