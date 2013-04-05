// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cvThreshold_cvAdaptiveThreshold;

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

const
  filename = 'Resource\cat2.jpg';

var
  src: pIplImage = nil;
  dst: pIplImage = nil;
  dst2: pIplImage = nil;

begin
  try
    // �������� ��������
    src := cvLoadImage(filename, CV_LOAD_IMAGE_GRAYSCALE);
    WriteLn(Format('[i] image: %s', [filename]));
    // ������� �����������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    cvShowImage('original', src);

    dst := cvCreateImage(cvSize(src^.width, src^.height), IPL_DEPTH_8U, 1);
    dst2 := cvCreateImage(cvSize(src^.width, src^.height), IPL_DEPTH_8U, 1);

    cvThreshold(src, dst, 50, 250, CV_THRESH_BINARY);
    cvAdaptiveThreshold(src, dst2, 250, CV_ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY, 7, 1);

    // ���������� ����������
    cvNamedWindow('cvThreshold', CV_WINDOW_AUTOSIZE);
    cvShowImage('cvThreshold', dst);
    cvNamedWindow('cvAdaptiveThreshold', CV_WINDOW_AUTOSIZE);
    cvShowImage('cvAdaptiveThreshold', dst2);

    // ��� ������� �������
    cvWaitKey(0);

    // ����������� �������
    cvReleaseImage(src);
    cvReleaseImage(dst);
    cvReleaseImage(dst2);
    // ������� ����
    cvDestroyAllWindows;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
