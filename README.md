# Global Fabric Day 2026 - (FUGE) - Online

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Microsoft Fabric](https://img.shields.io/badge/Microsoft-Fabric-blue)](https://www.microsoft.com/microsoft-fabric)
[![dbt](https://img.shields.io/badge/dbt-Data%20Build%20Tool-orange)](https://www.getdbt.com/)

Repositorio de apoyo para la charla **"SQL + dbt + Microsoft Fabric: evoluciona el desarrollo de tu Data Warehouse"**.

El objetivo de esta ponencia es mostrar un enfoque moderno para construir y operar un Data Warehouse en Microsoft Fabric, combinando:

- **Ingesta y orquestación**.
- **Modelado y transformaciones declarativas** con dbt Jobs.
- Uso de un artefacto Warehouse para **consumo y explotación**.

---

## Resumen

La demo presenta un flujo extremo a extremo sobre AdventureWorks:

1. Ingesta de datos en crudo en un Lakehouse.
2. Orquestación del proceso empleando un Data Pipeline de Fabric.
3. Transformación y pruebas con dbt en Microsoft Fabric.
4. Publicación de las entidades generadas en un Warehouse.

Este repositorio incluye tanto el código empleado en la demo como el material de la presentación.

---

## Contenidos

- [**/src**](src): código fuente de los artefactos de Microsoft Fabric usados en la demo.
- [**/docs**](docs): documentación y material de la charla.
- [**/.github/workflows**](.github/workflows): canalizaciones para despliegue y validación.

---

## Prerrequisitos

Para reproducir la demo en tu entorno, necesitas:

- Una capacidad activa de **Microsoft Fabric**.
- Un área de trabajo de **Microsoft Fabric** asociada a la capacidad, donde se tenga al menos permisos de Colaborador.
- Acceso a la base de datos [AdventureWorksLT](https://github.com/microsoft/sql-server-samples/releases/tag/adventureworks).

Si vas a automatizar despliegues desde GitHub Actions:

- Una entidad de servicio con permisos al menos de Colaborador sobre el área de trabajo.

---

## Instrucciones de uso

1. Bifurca este repositorio.
2. Sincroniza tu área de trabajo con la carpeta `/src` del repositorio.
3. Configura conexiones y parámetros necesarios para la ingesta.
4. Ejecuta la canalización de orquestación.

---

## Licencia

Este proyecto se distribuye bajo licencia [MIT](LICENSE).
