<template>
  <div>
    <v-container v-if="edit">
      <v-select 
        :loading="loading" 
        :label="'Currency ('+display+')'" 
        v-model="valueCurrency" 
        :items="items" 
        outlined 
        hide-details="auto" 
        :error-messages="err_messages"
        :error="error"
        item-text="display"
        item-value="code"
        dense
      ></v-select>
      <v-text-field :label="display" v-model="value.value" outlined hide-details="auto" dense>
      </v-text-field>

    </v-container>
    <div v-else>
      <v-row dense>
        <v-col cols="3" class="font-weight-bold">{{display}}</v-col>
        <v-col cols="9" v-if="loading">
          <v-progress-linear indeterminate color="primary"></v-progress-linear>
        </v-col>
        <v-col cols="9" v-else>{{value.value}} {{valueDisplay || ""}}</v-col>
      </v-row>
      <v-divider></v-divider>
    </div>
  </div>
</template>

<script>
/*
const itemSort = (a,b) => {
  return (a.display === b.display ? (a.code === b.code ? 0 : (a.code < b.code ? -1: 1)) : (a.display < b.display ? -1 : 1) )
}
*/
export default {
  name: "fhir-coding",
  props: ["field","label","sliceName","targetprofile","min","max","base-min","base-max","slotProps","path","binding","edit"],
  data: function() {
    return {
      value: { value: "", currency: "" },
      valueCurrency: "",
      valueDisplay: "",
      currencySystem: "urn:iso:std:iso:4217",
      currencyValueSet: "http://hl7.org/fhir/ValueSet/currencies",
      loading: true,
      err_messages: null,
      error: false,
      items: [],
      source: { path: "", data: {} }
    }
  },
  created: function() {
    this.setupData()
  },
  watch: {
    slotProps: {
      handler() {
        //console.log("WATCH CODING",this.path,this.slotProps)
        this.setupData()
      },
      deep: true
    },
    valueCurrency: function( code ) {
      /*
      if ( this.items ) {
        let findValue = this.items.find( item => item.code === code )
        if ( findValue ) {
          this.value = findValue
        }
      }
      */
      this.value.currency = code
      if ( this.value.currency ) {
        this.$fhirutils.codeLookup( this.currencySystem, this.value.value, this.currencyValueSet ).then( display => {
          this.valueDisplay = display
        } )
      }
    }
  },
  methods: {
    setupData: function() {
      if ( this.slotProps && this.slotProps.source ) {
        this.source = { path: this.slotProps.source.path+"."+this.field, data: {} }
        if ( this.slotProps.source.fromArray ) {
          this.source.data = this.slotProps.source.data
          // Need to see if this works and figure out what it needs to be
          if ( this.source.data ) {
            this.value = this.source.data
            this.valueCurrency = this.value.currency
            //console.log("set",this.value,this.valueCurrency)
          }
        } else {
          let expression = this.$fhirutils.pathFieldExpression( this.field )
          this.source.data = this.$fhirpath.evaluate( this.slotProps.source.data, expression )
          //console.log("FPATH info",this.path,this.slotProps)
          //console.log("FPATH setting value to",this.field,this.source.data[0],expression,this.slotProps.source.data)
          if ( this.source.data[0] ) {
            this.value = this.source.data[0]
            this.valueCurrency = this.value.currency
          }
        }
      }
      let binding = this.currencyValueSet
      this.$fhirutils.expand( binding ).then( items => {
        this.items = items 
        this.loading = false
      } ).catch( err => {
        console.log(err)
        this.error = true
        this.err_messages = err.message
        this.loading = false
      } )
    }
  },
  computed: {
    display: function() {
      if ( this.slotProps && this.slotProps.input) return this.slotProps.input.label
      else return this.label
    }
  }
}
</script>
