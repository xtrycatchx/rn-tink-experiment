import React, { Component } from 'react';
import { TouchableOpacity, View, Text, TextInput, Picker } from 'react-native';
import { encryptAsymmetric, encryptSymmetric } from './UglyCrypto';

export default class App extends Component {

  state = {
    encrypted: null,
    cipher: null
  }

  onPress = () => {
    const cipher = this.state.cipher === "Symmetric" ? encryptSymmetric : encryptAsymmetric
    cipher("hello", "what").then(encrypted => {
      this.setState({ encrypted })
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
        style={{height: 40, borderColor: 'gray', borderWidth: 1}}
        onChangeText={(text) => this.setState({text})}
        value={this.state.text}
      />

        <View style={{
          flexDirection: 'row',
          justifyContent: 'center',
          alignItems: 'center'
        }} >

          <Picker
            selectedValue={this.state.cipher}
            style={{ height: 20, width: 100, marginTop: -200 }}
            itemStyle={{ backgroundColor: "#141513", color: "#638149", fontSize: 17 }}
            onValueChange={itemValue => this.setState({ cipher: itemValue })}>
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

        {this.state.encrypted && <View style={{ margin: 20, padding: 20, backgroundColor: "#141544" }}>
          <Text style={{
            color: '#ddd',
            fontStyle: 'normal',
          }}>
            {this.state.encrypted}
          </Text>
        </View>}
      </View>
    );
  }
}
