function C2=MatlabSOS2CMSIS(fname,SOS,G)
%MatlabSOS2CMSIS convert Matlab SOS  to CMSIS format
% C=MatlabSOS2CMSIS(fname,SOS,G) writes a C header file called fname
% containing the parameters to implement a CMSIS Biquad Cascade IIR Filters 
% Using Direct Form I Structure. SOS and G are Second Order Sections and
% gains produced by Matlab. 
% Phil Birch 2017

Coeffs=SOS;
%remove a00 
Coeffs(:,4)=[];
%swap a signs
Coeffs(:,4:5)=-Coeffs(:,4:5);
%remove final gain
Gain=G(1:end-1);
%combine gains and SOS
C2=zeros(size(Coeffs));
for p=1:5
    if p<4
    C2(:,p)=Coeffs(:,p).*Gain;
    else
        C2(:,p)=Coeffs(:,p);
    end
end


fid=fopen(fname,'wt');
fprintf(fid,'/* Generated with MatlabSOS2CMSIS\nPhil Birch, University of Sussex, 2017*/\n');
fprintf(fid,'#define NUM_SECTIONS %d\n',length(Gain));
fprintf(fid,'float32_t pCoeffs[]={');
for p=1:size(C2,1)
    fprintf(fid,' %2.8E,',C2(p,:));
    if p==size(C2,1)
        fprintf(fid,'};\n');
    else
        fprintf(fid,'\n');
    end
end
fprintf(fid,'\n/*Example usage:\n#include "%s"\nfloat32_t pState[NUM_SECTIONS*4]={0};',fname);
fprintf(fid,'\narm_biquad_casd_df1_inst_f32 S;\n\nIn the your main function init the filter\narm_biquad_cascade_df1_init_f32(&S,NUM_SECTIONS,pCoeffs,pState);\n');
fprintf(fid,'To run the filter:\narm_biquad_cascade_df1_f32(&S,pSrc,pDest,BUFFER_SIZE);\nSee CMSIS doc for varible descriptions\n*/');




