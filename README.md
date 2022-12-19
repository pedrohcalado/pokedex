# Pokedex

## Descrição
Criar uma Pokedex utilizando a [PokeAPi V2](https://pokeapi.co/docs/v2), mostrando uma lista de Pokemons e os detalhes de cada Pokemon quando um deles é selecionado.

<img src="https://raw.githubusercontent.com/pedrohcalado/pokedex/main/.github/home.png" width="200"> <img src="https://raw.githubusercontent.com/pedrohcalado/pokedex/main/.github/pokemon_details.png" width="200"> <img src="https://raw.githubusercontent.com/pedrohcalado/pokedex/main/.github/ability_description.png" width="200"> 
<img src="https://raw.githubusercontent.com/pedrohcalado/pokedex/main/.github/same_type_pokemons.png" width="200"> 

## Requisitos 
### Tela com lista de Pokemons
- [x] Busca por ID ou Nome utilizando o Search Controller
- [x] Paginação com endless scrolling
- [x] Foto default do Pokémon na listagem

### Tela de detalhes
- [x] Nome e ID
- [x] Carrossel com as fotos disponíveis do Pokémon
- [x] View com os stats do Pokémon (hp, attack, defense, special attack, special, defense, speed)
- [x] Exibir suas Habilidades (Run Away, Adaptability, Synchronize etc)
- [x] Ao tocar em uma habilidade, exibir um modal com a descrição
- [x] Exibir seus tipos (electric, ground, water, fire etc)
- [x] Ao tocar em um tipo, exibir a lista dos Pokémons desse mesmo tipo
- [ ] Exibir a cadeia de evolução do Pokémon
- [x] Exibir um picker que permita selecionar as variações do Pokémon (ao selecionar uma variação, o app deve carregar automaticamente os dados da variação selecionada).

## Requisitos Técnicos
- [x] Desenvolva em Swift
- [x] Utilizar alguma arquitetura de projeto (MVC, MVVM, Clean etc)
- [x] Utilizar Alamofire para realizar os request às API's
- [x] Utilizar o protocolo nativo para mapping de JSON (Codable)
- [x] Tratar erros nas chamadas
- [x] Não utilizar nenhum wrapper para a Pokémon API

## Requisitos Extra
- [ ] Testes unitários e instrumentados
- [ ] Cache das imagens e dos requests para APIs
- [ ] Utilizar Custom View Controller Transitions
- [x] Seguir as guidelines do Human Interface Guidelines da Apple
- [ ] Conseguir as imagens dos posters e personagens de alguma API pública
- [x] Construir layouts com Auto Layout
- [ ] Trabalhar offline (cache dos dados)
- [x] Utilizar RxSwift

## Tecnologias e metodologias utilizadas
- UIKit
- Swift
- RxSwift
- MVVM-C
- XCTest
- View Code
- Auto Layout
- Codable
- SDWebImage
- Alamofire


