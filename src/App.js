import React, { Component } from 'react';
import { TouchableOpacity, View, Text, TextInput, Picker, Dimensions } from 'react-native';
import { encryptAsymmetric, encryptSymmetric } from './UglyCrypto';

export default class App extends Component {

  state = {
    output: null,
    plain: 'Useless Placeholder',
    cipher: null
  }

  onPress = () => {
    const cipher = this.state.cipher === "Symmetric" ? encryptSymmetric : encryptAsymmetric
    cipher(this.state.plain, "what").then(output => {
      this.setState({ output })
    })
  }

  render() {
    return (
      <View style={{
        flex: 1,
        backgroundColor: '#141513',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center'
      }} >

      <TextInput
        style={{height: 40,backgroundColor: "#000", color: "gray", padding: 10, width: Dimensions.get('window').width-50, borderColor: 'gray', borderWidth: .5}}
        onChangeText={(plain) => this.setState({plain})}
        value={this.state.plain}
      />

        <View style={{
          flexDirection: 'row',
          justifyContent: 'center',
          alignItems: 'center'
        }} >

          <Picker
            selectedValue={this.state.cipher}
            style={{ width: 100, }}
            itemStyle={{ backgroundColor: "#141513", color: "#638149", fontSize: 17 }}
            onValueChange={cipher => this.setState({ cipher})}>
            <Picker.Item key="Symmetric" label="AEAD" value="Symmetric" />
            <Picker.Item key="Assymetric" label="HYBRID" value="Assymetric" />
          </Picker>

          <TouchableOpacity
            onPress={this.onPress}
            activeOpacity={60}
            style={{
              borderRadius: 20,
              padding: 14,
              backgroundColor: '#638149',
              margin: 20,
            }}
          >
            <Text style={{
              color: '#141513',
              fontStyle: 'normal',
            }}>
              Encrypt
            </Text>
          </TouchableOpacity>

        </View>

        {this.state.output && <View style={{ margin: 20, padding: 20, backgroundColor: "#141544" }}>
          <Text style={{
            color: '#ddd',
            fontStyle: 'normal',
          }}>
            {this.state.output}
          </Text>
        </View>}
      </View>
    );
  }
}
