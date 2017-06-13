function aoiinfo2= Gen_aoiinfo2_mapping(aoiinfo2,fitparmvector)
%The function Gen_aoiinfo2_mapping(aoiinfo2,fitparmvector) takes an aoiinfo2 vector containing XY
%centers in the long wavelength field and outputs a vector containing the
%XY centers mapped to the short wavelength field using a fitparmvector from
%a FitParms.dat file
%

                                     % map the present AOI set to 
                                                        % field #2 e.g. x1 -> x2
                                                        % (output is x2y2  coordinates)
     % fitparmvector=mapping parameters
     % Stored as [mxx21 mxy21 bx;
     %            myx21 myy21 by]
                %aoiinfo2=[ frm# ave AOIx  AOIy pixnum aoinum]

     nowpts=[aoiinfo2(:,3) aoiinfo2(:,4)];
                % Now map to the x2 
       
     aoiinfo2(:,3)=mappingfunc(fitparmvector(1,:),nowpts);
 %handles.FitData(:,3)=handles.FitData(:,3)*fitparmvector(1) + fitparmvector(2);
                % Now map to the y2 
     aoiinfo2(:,4)=mappingfunc(fitparmvector(2,:),nowpts);
 %handles.FitData(:,4)=handles.FitData(:,4)*fitparmvector(3) + fitparmvector(4);

                                % only keep points with pixel indices >=1
      log=(aoiinfo2(:,3)>=1 ) & (aoiinfo2(:,4) >=1);
      aoiinfo2=aoiinfo2(log,:);
      
end

