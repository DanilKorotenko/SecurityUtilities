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

    if (argc < 2)
    {
        std::cout << argv[0] << " --path <path to binary>" << std::endl;
        std::cout << argv[0] << " --pid <pid>" << std::endl;
        return EXIT_SUCCESS;
    }

    CodeSignInfoRef codeSignInfo = NULL;

    std::string parameter = argv[1];
    if (parameter == "--path")
    {
        codeSignInfo = CodeSignInfoCreateWithBinaryPath(argv[2]);
    }
    else if (parameter == "--pid")
    {
        int pid = atoi(argv[2]);
        codeSignInfo = CodeSignInfoCreateWithPid(pid);
    }
    else
    {
        return EXIT_SUCCESS;
    }

    std::cout << CodeSignInfoGetIdentifier(codeSignInfo) << std::endl;
    std::cout << CodeSignInfoGetCompanyName(codeSignInfo) << std::endl;

    CodeSignInfoReleaseAndMakeNull(&codeSignInfo);
    return EXIT_SUCCESS;
}
