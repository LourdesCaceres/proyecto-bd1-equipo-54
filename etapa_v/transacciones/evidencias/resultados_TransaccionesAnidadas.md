## Precio de los productos antes del aumento


<img width="563" height="257" alt="Captura de pantalla 2026-11-03 001401" src="https://github.com/user-attachments/assets/1c50a4c6-0ae6-47c2-81b3-d62653d8832f" />


## Primer caso


<img width="910" height="317" alt="Captura de pantalla 2026-11-03 001508" src="https://github.com/user-attachments/assets/3f3908d3-5149-4ba8-954f-960ac54dc353" />


## Segundo caso


<img width="1332" height="385" alt="Captura de pantalla 2026-11-03 001536" src="https://github.com/user-attachments/assets/e4808523-d97c-4909-a0fe-228ec8ba6cf4" />


## Tercer caso


<img width="1171" height="417" alt="Captura de pantalla 2026-11-03 001609" src="https://github.com/user-attachments/assets/5789df50-9081-401d-9034-64efa40d21ec" />


## Cuarto caso


<img width="1006" height="257" alt="Captura de pantalla 2026-11-03 001632" src="https://github.com/user-attachments/assets/d9f14bac-bd7b-4de5-98ac-add93e23803e" />


## Quinto caso 


<img width="1002" height="227" alt="Captura de pantalla 2026-11-03 001647" src="https://github.com/user-attachments/assets/0d2da5fc-8295-418d-a5c8-7c895537ae43" />


## Precios actualizados


<img width="992" height="682" alt="Captura de pantalla 2026-11-03 001751" src="https://github.com/user-attachments/assets/af344891-0564-481e-9f20-4e2ff67f605b" />


## CONCLUSIONES
Las pruebas de la transacción anidada muestran que el ajuste masivo de precios se comporta como una unidad atómica, aunque cada producto se actualice dentro de su propia transacción interna utilizando la función fn_PrecioAjustado. 

Los casos 2 y 3 son los que mas reflejan las ventajas de la transacción: cuando se detecta que algún producto supera el precio tope (RN.13), todos los productos de la categoría ya fueron actualizados y cada COMMIT interno solo había decrementado @@TRANCOUNT. El ROLLBACK del procedimiento externo deshace entonces la totalidad de los cambios, y los precios regresan a su valor original. Esto confirma que un COMMIT interno no persiste nada mientras la transacción externa siga abierta, y que la regla de negocio se hace cumplir de forma completa: el aumento se confirma entero (caso 1) o se cancela entero (casos 2 y 3). El caso 4 muestra que las validaciones previas evitan abrir transacciones innecesarias, y el caso 5 que el procedimiento interno, ejecutado solo, confirma de manera real.
