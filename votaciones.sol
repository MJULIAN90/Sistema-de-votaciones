// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.9.0;

// -----------------------------------
//  CANDIDATO   |   EDAD   |      ID
// -----------------------------------
//  Toni        |    20    |    12345X
//  Alberto     |    23    |    54321T
//  Joan        |    21    |    98765P
//  Javier      |    19    |    56789W

contract Votaciones{

    //Direccion del propietario del contrato
    address owner;

    constructor (){
        owner = msg.sender;
    }
    

    //Relacion entre nombre de candidato y el hash de sus datos 
    mapping (string => bytes32) idCandidato;

    //Relacion entre el nombre del candidato y el numero de votos
    mapping (string => uint ) votosCandidatos;

    //Lista para almacenar los nombres de los candidatos 
    string [] candidatos;

    //Lista de los hashes de la identidad de los votantes
    bytes32 [] votantes;

    //Cualquier persona puede usar esta funcion para presentarse a las elecciones
    function representar (string memory _nombrePersona, uint _edadPersona , string memory _idPersona)
    public {
        //Hash de los datos del candidato
        bytes32 hashCandidato = keccak256(abi.encodePacked(_nombrePersona, _edadPersona , _idPersona));

        //Almacenamos el hash de los datos del candidato ligados a su nombre
        idCandidato[_nombrePersona] = hashCandidato;

        //Almacenamos el nombre del candidato
        candidatos.push (_nombrePersona);
    }

    //Permite visualizar las personas que se han presentado como candidatos a las votaciones
    function verCandidatos ()public view returns (string [] memory){
        //Devuelve la lista de los candidatos presentados
        return candidatos;
    }

    //los votantes van a poder votar
    function votar (string memory _candidato) public{

        //Hash de la direccion de la persona que ejecuta esta funcion
        bytes32 hashVotante = keccak256(abi.encodePacked(msg.sender));

        //verficamos si el votante ya ha votado
        for (uint i=0; i<votantes.length; i++){
            require(votantes[i] != hashVotante, "Ya has votado previamente");
        }

        //Almacenamos el hash del votante dentro del array de votantes
        votantes.push(hashVotante);
        
        //Anadimos un voto el candidato seleccionado
        votosCandidatos[_candidato]++ ;
    }

    //Dado el nombre de un candidato nos devuelve el numero de votos que tiene 
    function verVotos(string memory _candidato) public view returns(uint){
        //Devolviendo el numero de votos del candidato
        return votosCandidatos[_candidato];
    }

    //Funcion auxiliar que transforma un uint a string 

        function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    } 

    //Ver los votos de cada uno de los candidatos
    function verResultados() public view returns(string memory){
        //Guardamos en una variable string los candidatos con sus respectivos votos
        string memory resultados = "";

        //Recorremos el array de candidatos para actualizar el string resultados
        for (uint i=0; i<candidatos.length; i++){
            //Actualizamos el string resultados y anadimos el candidato que ocupa la posicion "i" del array candidatos
            resultados = string(abi.encodePacked ( resultados , "(", candidatos[i], ",", uint2str(verVotos(candidatos[i])), ") -------"));
        }

        // Devolvemos los resultados
        return resultados;
    }

    //Proporcionar el nombre del candidato ganador
    function candidatoGanador() public view returns( string memory){
        //La variable ganador contendra el nombre del candidato ganador
        string memory ganador = candidatos[0];
        bool flag;

        //Recorremos el array de candidatos para determinar el candidato con un numero de votos mayor
        for (uint i=1; i<candidatos.length; i++){
            if(votosCandidatos[ganador] < votosCandidatos[candidatos[i]]){
                ganador = candidatos[i];
            }else{
                if(votosCandidatos[ganador] == votosCandidatos[candidatos[i]]){
                    flag=true;
                }
            }
            
        }
        if (flag == true) {
            ganador = "Hay empate entre los candidatos";
        }
        return ganador;
    }
}