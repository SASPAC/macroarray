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

SHA256 digest for the latest version of `macroArray`: F*3F3893F1FCD78719543703E4353F4CC19811D247C016F220FF729B283C1AD790

[**Documentation for macroArray**](./macroarray.md "Documentation for macroArray")

To work with a package use the [**SAS Packages Framework**](https://github.com/yabwon/SAS_PACKAGES/blob/main/README.md "SPFinit").

