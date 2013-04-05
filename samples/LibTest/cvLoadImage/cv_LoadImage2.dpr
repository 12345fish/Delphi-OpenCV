// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_LoadImage2;

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
  filename = 'Resource\opencv_logo_with_text.png';

Var
  image: pIplImage = nil;
  src: pIplImage = nil;

begin
  try
    // �������� ��������
    image := cvLoadImage(filename, 1);
    if Assigned(image) then
    begin
      // ��������� ��������
      src := cvCloneImage(image);
      if Assigned(src) then
      begin
        // ���� ��� ����������� ��������
        cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
        // ���������� ��������
        cvShowImage('original', image);
        // ������� � ������� ���������� � ��������
        WriteLn('src');
        with src^ do
        begin
          WriteLn(Format('[i] channels: %d', [nChannels]));
          WriteLn(Format('[i] pixel depth: %d bits', [depth]));
          WriteLn(Format('[i] width: %d pixels', [width]));
          WriteLn(Format('[i] height: %d pixels', [height]));
          WriteLn(Format('[i] image size: %d bytes', [imageSize]));
          WriteLn(Format('[i] width step: %d bytes', [widthStep]));
        end;
        WriteLn;
        WriteLn('original');
        with src^ do
        begin
          WriteLn(Format('[i] channels: %d', [nChannels]));
          WriteLn(Format('[i] pixel depth: %d bits', [depth]));
          WriteLn(Format('[i] width: %d pixels', [width]));
          WriteLn(Format('[i] height: %d pixels', [height]));
          WriteLn(Format('[i] image size: %d bytes', [imageSize]));
          WriteLn(Format('[i] width step: %d bytes', [widthStep]));
        end;
        // ��� ������� �������
        cvWaitKey(0);
        // ����������� �������
        cvReleaseImage(image);
        cvReleaseImage(src);
        // ������� ����
        cvDestroyWindow('original');
      end;
    end;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
