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

SHA256 digest for the latest version of `macroArray`: 371B92A5ABBE82C53F7D63BC5C0D1EBD4695603D3894D8A9A5D5777D1AB59B30

[**Documentation for macroArray**](./macroarray.md "Documentation for macroArray")



