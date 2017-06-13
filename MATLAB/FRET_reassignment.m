function new_data=FRET_reassignment(data,FRET_VALUES)

FRET_VALUES=unique(FRET_VALUES);%makes sure the fret values are unique

if size(FRET_VALUES,2)>size(FRET_VALUES,1)%rotates the fret vector if horizontal instead of vertical
   FRET_VALUES=FRET_VALUES'; 
end

new_data=data;%copies into new vector

for i=1:size(data,1)%steps through data
FRET_point=data(i,5);
    difference=abs(meshgrid(FRET_point,FRET_VALUES)-FRET_VALUES);%gets the differences to find the closest value
    pos=find(difference==min(difference));%finds the lowest values - the closest fret value
    new_data(i,5)=FRET_VALUES(pos);%writes to the new vector
end


end