- [SDOSCustomLoader](#sdoscustomloader)
  - [Introducción](#introducción)
  - [Instalación](#instalación)
    - [Cocoapods](#cocoapods)
    - [Swift Package Manager](#swift-package-manager)
      - [**En el "Project"**](#en-el-project)
      - [**En un Package.swift**](#en-un-packageswift)
  - [Cómo se usa](#cómo-se-usa)
  - [Referencias](#referencias)

# SDOSCustomLoader

- Enlace confluence: https://kc.sdos.es/x/qAXLAQ
- Changelog: https://github.com/SDOSLabs/SDOSCustomLoader/blob/master/CHANGELOG.md

## Introducción

SDOSCustomLoader ofrece una serie de loaders para poder usar en cualquier proyecto

## Instalación

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org).

Añadir el  "source" al `Podfile`:
```ruby
source 'https://github.com/SDOSLabs/cocoapods-specs.git'
```

Añadir la dependencia al `Podfile`:
```ruby
pod 'SDOSCustomLoader', '~>1.1.0' 
```

### Swift Package Manager

A partir de Xcode 12 podemos incluir esta librería a través de Swift package Manager. Existen 2 formas de añadirla a un proyecto:

#### **En el "Project"**

Debemos abrir nuestro proyecto en Xcode y seleccionar el proyecto para abrir su configuración. Una vez aquí seleccionar la pestaña "Swift Packages" y añadir el siguiente repositorio

```
https://github.com/SDOSLabs/SDOSCustomLoader.git
```

En el siguiente paso deberemos seleccionar la versión que queremos instalar. Recomentamos indicar "Up to Next Major" `1.1.0`.

Por último deberemos indicar el o los targets donde se deberá incluir la librería

#### **En un Package.swift**

Incluir la dependencia en el bloque `dependencies`:

``` swift
dependencies: [
    .package(url: "https://github.com/SDOSLabs/SDOSCustomLoader.git", .upToNextMajor(from: "1.1.0"))
]
```

Incluir la librería en el o los targets desados:

```js
.target(
    name: "YourDependency",
    dependencies: [
        "SDOSCustomLoader"
    ]
)
```

## Cómo se usa

Para utilizarlo se recomienda el uso de la dependencia [`SDOSLoader`](https://kc.sdos.es/x/pQXLAQ), que ofrece una fachada para la utilización de esta librería y otros loaders

## Referencias
* https://github.com/SDOSLabs/SDOSLoader
* [SDOSLoader](https://kc.sdos.es/x/pQXLAQ)
