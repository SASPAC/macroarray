### `macroArray` - Macroarrays for macro codes

---

The **macroArray** package implements an array, a hash table, and a dictionary concept in macrolanguage. For example:
```sas
  %array(ABC[17] (111:127), macarray=Y); 
  
  %macro test();
    %do i = 1 %to 17; 
      %put &i.) %ABC(&i.); 
    %end;
  %mend;
  %test() 
  
  %let %ABC(13,i) = 99999; /* i = insert */

  %do_over(ABC, phrase=%nrstr( 
      %put &_i_.%) %ABC(&_i_.); 
      ),
      which = 1:H:2
  );
```

SHA256 digest for the latest version of `macroArray`: DA57FFE85F49201FD61A53411D19E97FB5A6AC3C34E34FDF4B913545699551FF

[**Documentation for macroArray**](./macroarray.md "Documentation for macroArray")



