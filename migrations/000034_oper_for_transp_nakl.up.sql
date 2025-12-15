-- First, drop the existing primary key constraint
ALTER TABLE operators_for_transp_nakl 
DROP CONSTRAINT operators_for_transp_nakl_pkey;

-- Then, add the new composite primary key
ALTER TABLE operators_for_transp_nakl 
ADD PRIMARY KEY (user_id, production_site_id);
