//
//  main.cpp
//  codeSignUtility
//
//  Created by Danil Korotenko on 10/1/25.
//

#include <iostream>
#include "../SecurityUtilities/CodeSignInfo/CodeSignInfo.h"

int main(int argc, const char * argv[])
{
    std::cout << "Hello, Code sign!\n";

    CodeSignInfoRef codeSignInfo = CodeSignInfoCreateWithBinaryPath(
        "/Library/Developer/CommandLineTools/usr/libexec/git-core/git-remote-http");

    std::cout << CodeSignInfoGetIdentifier(codeSignInfo) << std::endl;

    CodeSignInfoReleaseAndMakeNull(&codeSignInfo);
    return EXIT_SUCCESS;
}
