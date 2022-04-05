#include<iostream>
#include<string>
#include<vector>
#include<Windows.h>
#include<cstring>
#pragma warning(disable:4996)

using namespace std;

class a1111
{
private:
	int a;
public:
	a1111(int aa) :a(aa)
	{ }

	int geta() { return a; }
};

int main(void)
{
	a1111 aaa(1);
	cout << aaa.geta();

	return 0;
}
