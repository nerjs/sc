pragma solidity ^0.4.0;

contract ForEach {
    address public first;
    address public last;
    uint public length;
    
    struct MapAdd {
        address prev;
        address next;
    }
    
    
    mapping (address => MapAdd) public list;
    
    function isOnce(address target) private {
        if (length == 0) {
            first = target;
            last = target;
        }
    }
    
    // есть ли в массиве
    function inList(address target) view public returns(bool) {
        return (list[target].prev != 0x0 || list[target].next != 0x0 || first == target);
    }
    
    
    //удаляем по аддресу
    function remove(address target) public returns(bool) {
        if (!inList(target)) return false;
        if (list[target].prev == 0x0) {
            first = list[target].next;
            list[first].prev = 0x0;
        } else {
            list[list[target].prev].next = list[target].next;
        }
        
        if (list[target].next == 0x0) {
            last = list[target].prev;
            list[last].next = 0x0;
        } else {
            list[list[target].next].prev = list[target].prev;
        }
        
        list[target] = MapAdd(0x0,0x0);
        
        length -= 1;
        
        return true;
    }
    
    // Добавляем в конец
    function push(address target) public returns(bool) {
        if (target == 0x0) return false;
        if (inList(target)) {
            remove(target);
        }
        
        list[target] = MapAdd(last,0x0);
        list[last].next = target;
        last = target;
        isOnce(target);
        length += 1;
        return true;
    }
    
    // добавляем в начало
    function unshift(address target) public returns(bool) {
        if (target == 0x0) return false;
        if (inList(target)) {
            remove(target);
        }
        list[first].prev = target;
        list[target] = MapAdd(0x0,first);
        first = target;
        isOnce(target);
        length += 1;
        return true;
    }
    // удаляем первый
    function shift() public returns(bool) {
        return remove(first);
    }
    // удаляем последний   
    function pop() public returns(bool) {
        return remove(last);
    }
    
    function next(address target) view public returns(address) {
        return list[target].next;
    }
    
    function prev(address target) view public returns(address) {
        return list[target].prev;
    }
    
}