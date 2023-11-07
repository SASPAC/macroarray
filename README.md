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

SHA256 digest for the latest version of `macroArray`: F*8689194590698F9A00B57FB37BE3CA8D7330F16B3E591CEAF49E6BE0B70D61D0

[**Documentation for macroArray**](./macroarray.md "Documentation for macroArray")

To work with a package use the [**SAS Packages Framework**](https://github.com/yabwon/SAS_PACKAGES/blob/main/README.md "SPFinit").

