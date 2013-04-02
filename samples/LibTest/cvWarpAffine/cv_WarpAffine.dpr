// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_WarpAffine;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Core.types_c in '..\..\..\include\�ore\Core.types_c.pas',
  core_c in '..\..\..\include\�ore\core_c.pas',
  highgui_c in '..\..\..\include\highgui\highgui_c.pas',
  imgproc.types_c in '..\..\..\include\imgproc\imgproc.types_c.pas',
  imgproc_c in '..\..\..\include\imgproc\imgproc_c.pas',
  uLibName in '..\..\..\include\uLibName.pas',
  types_c in '..\..\..\include\�ore\types_c.pas';

const
  filename = 'Resource\cat2.jpg';

var
  src: pIplImage = nil;
  dst: pIplImage = nil;
  rot_mat: pCvMat = nil;
  scale: double;
  temp: pIplImage = nil;
  center: TcvPoint2D32f;

begin

  // �������� �������� (�������)
  src := cvLoadImage(filename, CV_LOAD_IMAGE_COLOR);
  WriteLn(Format('[i] image: %s', [filename]));

  // ������� ��������
  cvNamedWindow('Original', CV_WINDOW_AUTOSIZE);
  cvShowImage('Original', src);

  // ������������
  // ������� �������������
  rot_mat := cvCreateMat(2, 3, CV_32FC1);
  // �������� ������������ ������ �����������
  center.x := src^.width div 2;
  center.y := src^.height div 2;
  scale := 1;
  cv2DRotationMatrix(center, 60, scale, rot_mat);

  // ������� �����������
  temp := cvCreateImage(cvSize(src^.width, src^.height), src^.depth, src^.nChannels);

  // ��������� ��������
  cvWarpAffine(src, temp, rot_mat, CV_INTER_LINEAR or CV_WARP_FILL_OUTLIERS, cvScalarAll(0));

  // �������� �����������
  cvCopy(temp, src);

  // ����������� �������
  cvReleaseImage(temp);
  cvReleaseMat(rot_mat);

  // ���������� ��� ����������
  cvNamedWindow('cvWarpAffine', CV_LOAD_IMAGE_GRAYSCALE);
  cvShowImage('cvWarpAffine', src);

  // ��� ������� �������
  cvWaitKey(0);

  // ����������� �������
  cvReleaseImage(src);
  cvReleaseImage(dst);
  cvDestroyAllWindows();

end.
