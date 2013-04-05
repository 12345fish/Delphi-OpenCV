// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_InRangeS;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
{$I ..\..\uses_include.inc}
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

    cvInRangeS(src, cvScalar(50), cvScalar(255), dst);

    // ���������� ����������
    cvNamedWindow('cvInRangeS', CV_WINDOW_AUTOSIZE);
    cvShowImage('cvInRangeS', dst);

    // ��� ������� �������
    cvWaitKey(0);

    // ����������� �������
    cvReleaseImage(src);
    cvReleaseImage(dst);
    // ������� ����
    cvDestroyAllWindows();
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
