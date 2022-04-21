//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import './Utils.sol';
import './Renderer.sol';

contract Playground {
    function example() external view returns (string memory) {
        LetterData memory data;
        data.bgColor = 'black';
        data.textColor = 'white';
        data
            .stampImageUrl = 'https://www.trustedreviews.com/wp-content/uploads/sites/54/2021/02/Rickrolling-in-4K-920x595.jpg';
        data.message = 'sup fam';

        return
            renderer.render(
                '0xa5cc3c03994DB5b0d9A5eEdD10CabaB0813678AC',
                '0xa5cc3c03994DB5b0d9A5eEdD10CabaB0813678AC',
                data
            );
    }
}
