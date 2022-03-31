pragma solidity 0.5.16;
//pragma solidity >=0.7.0 <0.9.0;
//pragma abicoder v2;


//test contract address: 0x7Ad0D5150bAbfd20F3B7934d06c5AE53B0665Ca3
contract BsbToken {
    
    //адрес владельца контракта
    address owner;

    //Получение адреса основного владельца
    function getOwner() public view returns(address result){
      return owner;
    }


    //Конструктор смартконтракта
    constructor() public payable {
        //Первый владелец - тот кто создает смарт
        owner = msg.sender;
        //Переводим все токены на баланс владельца контракта
        balanceOf[msg.sender] = totalSupply;
    }
    



    //ERC 20-functions

    //function totalSupply() external view returns (uint256);


    //Всего токенов выпущено
    uint256 public totalSupply = 1000000000000000000;    
    //Количество знаков после запятой
    uint8 public decimals = 18;
    //Полное название токена
    string public name = "BSB Token";
    //Сокращенное название токена
    string public symbol = "BSBT";

    

    //Здесь храним балансы пользователей адрес => баланс
    mapping (address => uint256) public balanceOf;


    //Возвращаем количество токенов которые разрешены на перевод вледельцем _owner стороннему пользователю _spender (по стандарту ERC-20)
    function allowance(address _owner, address _spender) external view returns (uint256){
      return allowed[_owner][_spender];
    }


    //Перевод _amount токенов от пользователя вызывшему функцию - пользователю _recipient
    function transfer(address _recipient, uint256 _amount) external returns (bool){
      //Проверяем достатончно ли средств на балансе
      if(balanceOf[msg.sender] >= _amount){
        //Уменьшаем баланс пользователя вызвавшего функцию
        balanceOf[msg.sender] -= _amount;
        //Увеличиваем баланс бользователя _recipient
        balanceOf[_recipient] += _amount;
        //Cообщаем, что все прошло успешно
        return true;
      }else{
        //Сообщаем что перевод не удался (не достаточно средств на балансе)
        return false;
      }

    }

    //Выдаем разрешение пользователю _spender на перевод _amount - токенов пользователя вызывшего функцию
    function approve(address _spender, uint256 _amount) external returns (bool){
      allowed[msg.sender][_spender] = _amount;
      emit Approval(msg.sender, _spender, _amount);
      return true;
    }

    //Преводим токены в количестве _amount от пользователя _from пользователю _to 
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool){
      //Если на баленсе пользователя _amount достаточно средств, если пользователь _from (владелец токенов) разрешил перевод токенов в количестве _amount пользователю вызывшему функцию, и если сумма перевода > 0
      if (balanceOf[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0) {
        //Увеличиваем баланс пользователя _to
        balanceOf[_to] += _amount;
        //Уменьшаем баланс пользователя _from
        balanceOf[_from] -= _amount;
        //Уменьшеаем разрешенную сумму перевода на _amount
        allowed[_from][msg.sender] -= _amount;
        //Вызываем событие перевода
        emit Transfer(_from, _to, _amount);
        //Возвращаем, что перевод прошел успешно
        return true;
      } else { 
        //Возвращаем, что перевод не удался
        return false; 
      }

    }


    //Здесь храним разрешения которые выдал владелец токенов стороннему пользователю на перевод токенов в определенном количестве
    mapping (address => mapping (address => uint256)) allowed;

    //Событие перевода
    event Transfer(address indexed from, address indexed to, uint256 value);
    //Событие разрешение на перевод
    event Approval(address indexed owner, address indexed spender, uint256 value);



    //Функция возвращает true, если пользователь является владельцем смартконтракта
    function isOwner() public view returns(bool result){
      if(msg.sender == owner){
        return true;
      }
      else{
        return false;
      }
    }





}