import ballerina/http;
import ballerina/graphql;
//import ballerina/io;

public type DistrictAndCityByProvinceResponse record {|
    map<json?> __extensions?;
    record {|
        record {|
            record {|
                string name_en;
            |} name;
            record {|
                record {|
                    string name_en;
                |} name;
                record {|
                    record {|
                        string name_en;
                    |} name;
                |}[] cities;
            |}[] districts;
        |} province;
    |} geo;
|};

type OperationResponse record {| anydata...; |}|record {| anydata...; |}[]|boolean|string|int|float|();

type DataResponse record {|
   map<json?> __extensions?;
   OperationResponse ...;
|};

isolated function performDataBinding(json graphqlResponse, typedesc<DataResponse> targetType)
                                    returns DataResponse|graphql:RequestError {
    do {
        map<json> responseMap = <map<json>>graphqlResponse;
        json responseData = responseMap.get("data");
        if (responseMap.hasKey("extensions")) {
            responseData = check responseData.mergeJson({"__extensions": responseMap.get("extensions")});
        }
        DataResponse response = check responseData.cloneWithType(targetType);
        return response;
    } on fail var e {
        return error graphql:RequestError("GraphQL Client Error", e);
    }
}

final graphql:Client graphqlClient = check new ("https://3a907137-52a3-4196-9e0d-22d054ea5789-dev.e1-us-east-azure.choreoapis.dev/mhbw/global-data-graphql-api/1.0.0/graphql");

public isolated function districtAndCityByProvince(string name) returns DistrictAndCityByProvinceResponse|graphql:ClientError {
    string query = string `query DistrictAndCityByProvince($name:String!) {geo {province(name:$name) {name {name_en} districts {name {name_en} cities {name {name_en}}}}}}`;
    map<anydata> variables = {"name": name};
    json graphqlResponse = check graphqlClient->executeWithType(query, variables, 
    headers = {"API-Key": "eyJraWQiOiJnYXRld2F5X2NlcnRpZmljYXRlX2FsaWFzIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiI3ODNmMmNiMi01ZWQyLTQ4OTMtYjA1NC0yMTc5NGNlYzhmOTBAY2FyYm9uLnN1cGVyIiwiaXNzIjoiaHR0cHM6XC9cL3N0cy5jaG9yZW8uZGV2OjQ0M1wvb2F1dGgyXC90b2tlbiIsImtleXR5cGUiOiJQUk9EVUNUSU9OIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1YnNjcmliZXJUZW5hbnREb21haW4iOm51bGwsIm5hbWUiOiJHbG9iYWwgRGF0YSBHcmFwaFFMIEFQSSIsImNvbnRleHQiOiJcLzNhOTA3MTM3LTUyYTMtNDE5Ni05ZTBkLTIyZDA1NGVhNTc4OVwvbWhid1wvZ2xvYmFsLWRhdGEtZ3JhcGhxbC1hcGlcLzEuMC4wIiwicHVibGlzaGVyIjoiY2hvcmVvX3Byb2RfYXBpbV9hZG1pbiIsInZlcnNpb24iOiIxLjAuMCIsInN1YnNjcmlwdGlvblRpZXIiOm51bGx9XSwiZXhwIjoxNjY0NTYwOTQyLCJ0b2tlbl90eXBlIjoiSW50ZXJuYWxLZXkiLCJpYXQiOjE2NjQ1MDA5NDIsImp0aSI6IjI1MzgyOWFlLTJkZDgtNDZhZS05ZjgwLWE5NmI5ZmU5NGRkYiJ9.S-4DiYNCuWI4dSBH68GACscoKaJPKyTqcpY73BqHSYJGulmMZsPF6CJ1rSl4uF10W7H02W_3tQAsEOB2i9LRqW1QovHeItstLHo37Mlt4jPIZZKocYFgM8vXs-aQfP_zCFbBsO1qSyPB4GDrowtuV0AtHIwv5pMZHGF6mdsl7t_xdf7ms9pJVNi3DsHAKfu_wuPQn4cKBgZTCACaogW5ETOX2-7JpUSgLDwwrViJbBh1N47tTx6FNfrc13esH4WYx1PNb5MPv6IiGDLRT_UxNfwZXrYYZvx_p-XpQXnI0vl9GOuI0SaP-GyNudPKZXtrVYJg-EkXHtEx__ag39PWgGlj2cGKZ7fOoFtOeTWLB_fKGYDAwkTPknBk-32oMQVZRgoiqAAwmHZLIfT9I2cH0xEzxUjJdmJEG8nbs554oQxeijbxkBenb2HfGT3iXaQmTXP4EOWywPGruYi-neK0vL61kG0LP_6fhxqT3rAKO9BXyhGVbu-RCXb57hBOxqi68O_kQyOUaV1DCY3Gd9orvQZaKtyz3B1XK5V31ltxZcvJJz25iTcDZwZrLppMK_GsPbH5uwPgk931Tl-BH3epwa6HuQ2Y4e45ynDxPQNfVmmRS9wa7fTldYFMfO6e5niNDYRSuUVHYibn26uBiGZi2OIv05_F2CM1NFsSksFF16U"});
    return <DistrictAndCityByProvinceResponse> check performDataBinding(graphqlResponse, DistrictAndCityByProvinceResponse);
}

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(string name) returns DistrictAndCityByProvinceResponse|error {
        DistrictAndCityByProvinceResponse|graphql:ClientError districtAndCityByProvinceResponse = districtAndCityByProvince(name);
        // Send a response back to the caller.
        if name is "" {
            return error("name should not be empty!");
        }
        return districtAndCityByProvinceResponse;
    }
}
