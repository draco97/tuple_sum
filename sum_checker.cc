#include <bits/stdc++.h>
#include <iostream>
#include <vector>
using namespace std;

/* Find triplet numbers that add up to 0*/
int main()
{
	int arr_size;
	cout<<"Enter the num of elements:";
	cin>>arr_size;
	int A[arr_size];
	for(int i=0;i<arr_size;i++){
		cout<<"Element no. "<<i+1<<": ";
		cin>>A[i];
	}
	int sum = 0;
    std::vector<std::array<int, 3>> output = std::vector<std::array<int, 3>>();

    for (int i = 0; i < arr_size - 2; i++)
	{

		// Find pair in subarray A[i+1..n-1]
		// with sum equal to sum - A[i]
		unordered_set<int> s;
		int curr_sum = sum - A[i];
		for (int j = i + 1; j < arr_size; j++)
		{
			if (s.find(curr_sum - A[j]) != s.end())
			{
				output.push_back({A[i], curr_sum-A[j], A[j]});
			}
			s.insert(A[j]);
		}
	}
    printf("Output:\n{");
    for(array<int,3> i : output){
        printf("[%d,%d,%d];",i[0],i[1],i[2]);
    }
    printf("}");
	return 0;
}
